package com.amap.flutter.location;

import android.content.Context;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.amap.api.location.AMapLocationClient;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class AMapLocationPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private static final String CHANNEL_METHOD_LOCATION = "amap_flutter_location";
    private static final String CHANNEL_STREAM_LOCATION = "amap_flutter_location_event";

    private MethodChannel channel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private Context context;
    private ConcurrentHashMap<String, AMapLocationClientImpl> locationClientMap = new ConcurrentHashMap<>(8);

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        if (context == null) {
            context = flutterPluginBinding.getApplicationContext();
        }

        // 方法调用通道
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_METHOD_LOCATION);
        channel.setMethodCallHandler(this);

        // 回调监听通道
        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_STREAM_LOCATION);
        eventChannel.setStreamHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Map<String, Object> arguments = call.arguments();

        switch (call.method) {
            case "updatePrivacyAgree":
                updatePrivacyAgree(arguments);
                break;
            case "updatePrivacyShow":
                updatePrivacyShow(arguments);
                break;
            case "setApiKey":
                setApiKey(arguments);
                break;
            case "setLocationOption":
                setLocationOption(arguments);
                break;
            case "startLocation":
                startLocation(arguments);
                break;
            case "stopLocation":
                stopLocation(arguments);
                break;
            case "destroy":
                destroy(arguments);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
        for (AMapLocationClientImpl client : locationClientMap.values()) {
            client.destroy();
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        for (AMapLocationClientImpl client : locationClientMap.values()) {
            client.stopLocation();
        }
    }

    private void startLocation(Map<String, Object> argsMap) {
        AMapLocationClientImpl client = getLocationClientImp(argsMap);
        if (client != null) {
            client.startLocation();
        }
    }

    private void stopLocation(Map<String, Object> argsMap) {
        AMapLocationClientImpl client = getLocationClientImp(argsMap);
        if (client != null) {
            client.stopLocation();
        }
    }

    private void destroy(Map<String, Object> argsMap) {
        String pluginKey = getPluginKeyFromArgs(argsMap);
        if (pluginKey != null) {
            AMapLocationClientImpl client = locationClientMap.get(pluginKey);
            if (client != null) {
                client.destroy();
                locationClientMap.remove(pluginKey);
            }
        }
    }

    private void setApiKey(Map<?, ?> apiKeyMap) {
        if (apiKeyMap != null && apiKeyMap.containsKey("android")) {
            Object androidKey = apiKeyMap.get("android");
            if (androidKey instanceof String && !((String) androidKey).isEmpty()) {
                AMapLocationClient.setApiKey((String) androidKey);
            }
        }
    }

    private void updatePrivacyAgree(Map<String, Object> privacyAgreeMap) {
        if (privacyAgreeMap != null && privacyAgreeMap.containsKey("hasAgree")) {
            try {
                AMapLocationClient.updatePrivacyAgree(context, (Boolean) privacyAgreeMap.get("hasAgree"));
            } catch (Throwable e) {
                // Handle exception
            }
        }
    }

    private void updatePrivacyShow(Map<?, ?> privacyShowMap) {
        if (privacyShowMap != null && privacyShowMap.containsKey("hasContains") && privacyShowMap.containsKey("hasShow")) {
            try {
                AMapLocationClient.updatePrivacyShow(
                        context,
                        (Boolean) privacyShowMap.get("hasContains"),
                        (Boolean) privacyShowMap.get("hasShow")
                );
            } catch (Throwable e) {
                // Handle exception
            }
        }
    }

    private void setLocationOption(Map<String, Object> argsMap) {
        AMapLocationClientImpl client = getLocationClientImp(argsMap);
        if (client != null) {
            client.setLocationOption(argsMap);
        }
    }

    private AMapLocationClientImpl getLocationClientImp(Map<String, Object> argsMap) {
        if (null == locationClientMap) {
            locationClientMap = new ConcurrentHashMap<String, AMapLocationClientImpl>(8);
        }

        String pluginKey = getPluginKeyFromArgs(argsMap);
        if (TextUtils.isEmpty(pluginKey)) {
            return null;
        }

        if (!locationClientMap.containsKey(pluginKey)) {
            AMapLocationClientImpl locationClientImp = new AMapLocationClientImpl(context, pluginKey, eventSink);
            locationClientMap.put(pluginKey, locationClientImp);
        }
        return locationClientMap.get(pluginKey);
    }

    private String getPluginKeyFromArgs(Map<String, Object> argsMap) {
        String pluginKey = null;
        try {
            if (argsMap != null && argsMap.containsKey("pluginKey")) {
                pluginKey = (String) argsMap.get("pluginKey");
            }
        } catch (Throwable e) {
            // e.printStackTrace();
        }
        return pluginKey;
    }
}