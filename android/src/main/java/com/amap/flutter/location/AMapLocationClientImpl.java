package com.amap.flutter.location;

import android.content.Context;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;

import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class AMapLocationClientImpl implements AMapLocationListener {
    private final Context context;
    private final String pluginKey;
    private final EventChannel.EventSink eventSink;
    private AMapLocationClientOption locationOption;
    private AMapLocationClient locationClient;

    public AMapLocationClientImpl(Context context, String pluginKey, EventChannel.EventSink eventSink) {
        this.context = context;
        this.pluginKey = pluginKey;
        this.eventSink = eventSink;
        this.locationOption = new AMapLocationClientOption();

        try {
            locationClient = new AMapLocationClient(context);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 开始定位
     */
    public void startLocation() {
        try {
            if (locationClient == null) {
                locationClient = new AMapLocationClient(context);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (locationClient != null) {
            locationClient.setLocationOption(locationOption);
            locationClient.setLocationListener(this);
            locationClient.startLocation();
        }
    }

    /**
     * 停止定位
     */
    public void stopLocation() {
        if (locationClient != null) {
            locationClient.stopLocation();
            locationClient.onDestroy();
            locationClient = null;
        }
    }

    public void destroy() {
        if (locationClient != null) {
            locationClient.onDestroy();
            locationClient = null;
        }
    }

    @Override
    public void onLocationChanged(AMapLocation aMapLocation) {
        if (eventSink != null) {
            Map<String, Object> result = Utils.buildLocationResultMap(aMapLocation);
            result.put("pluginKey", pluginKey);
            eventSink.success(result);
        }
    }

    /**
     * 设置定位参数
     */
    public void setLocationOption(Map<?, ?> optionMap) {
        locationOption = new AMapLocationClientOption();

        if (optionMap.containsKey("locationInterval")) {
            locationOption.setInterval(((Integer) optionMap.get("locationInterval")).longValue());
        }

        if (optionMap.containsKey("needAddress")) {
            locationOption.setNeedAddress((Boolean) optionMap.get("needAddress"));
        }

        if (optionMap.containsKey("locationMode")) {
            try {
                locationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.values()[(Integer) optionMap.get("locationMode")]);
            } catch (Throwable e) {
                // 忽略异常
            }
        }

        if (optionMap.containsKey("geoLanguage")) {
            locationOption.setGeoLanguage(AMapLocationClientOption.GeoLanguage.values()[(Integer) optionMap.get("geoLanguage")]);
        }

        if (optionMap.containsKey("onceLocation")) {
            locationOption.setOnceLocation((Boolean) optionMap.get("onceLocation"));
        }

        if (locationClient != null) {
            locationClient.setLocationOption(locationOption);
        }
    }
}
