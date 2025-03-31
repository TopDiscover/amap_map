package com.amap.flutter.map;

import androidx.annotation.NonNull;
import androidx.lifecycle.Lifecycle;

import com.amap.flutter.location.AMapLocationPlugin;
import com.amap.flutter.map.utils.LogUtil;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference;
import com.amap.flutter.search.AMapSearchPlugin;

/**
 * AmapFlutterMapPlugin
 */
public class AMapFlutterMapPlugin implements
        FlutterPlugin,
        ActivityAware {
    private static final String CLASS_NAME = "AMapFlutterMapPlugin";
    private static final String VIEW_TYPE = "com.amap.flutter.map";
    private Lifecycle lifecycle;
    private FlutterPluginBinding pluginBinding;
    private AMapLocationPlugin locationPlugin;
    private AMapSearchPlugin searchPlugin;

    public AMapFlutterMapPlugin() {
    }

    // FlutterPlugin

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        LogUtil.i(CLASS_NAME, "onAttachedToEngine==>");
        this.pluginBinding = binding;
        binding
                .getPlatformViewRegistry()
                .registerViewFactory(
                        VIEW_TYPE,
                        new AMapPlatformViewFactory(
                                binding.getBinaryMessenger(),
                                () -> lifecycle));
        
        // 注册定位插件
        locationPlugin = new AMapLocationPlugin();
        locationPlugin.onAttachedToEngine(binding);

        // 注册搜索插件
        searchPlugin = new AMapSearchPlugin();
        searchPlugin.onAttachedToEngine(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        LogUtil.i(CLASS_NAME, "onDetachedFromEngine==>");
        if (locationPlugin != null) {
            locationPlugin.onDetachedFromEngine(binding);
        }
        if (searchPlugin != null) {
            searchPlugin.onDetachedFromEngine(binding);
        }
    }


    // ActivityAware

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        LogUtil.i(CLASS_NAME, "onAttachedToActivity==>");
        HiddenLifecycleReference reference = (HiddenLifecycleReference) binding.getLifecycle();
        lifecycle = reference.getLifecycle();
        pluginBinding.getPlatformViewRegistry().registerViewFactory(
                VIEW_TYPE,
                new AMapPlatformViewFactory(
                        pluginBinding.getBinaryMessenger(),
                        () -> lifecycle
                )
        );

        // 注册搜索插件
        searchPlugin = new AMapSearchPlugin();
        searchPlugin.onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        LogUtil.i(CLASS_NAME, "onDetachedFromActivity==>");
        if (searchPlugin != null) {
            searchPlugin.onDetachedFromActivity();
        }
        lifecycle = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        LogUtil.i(CLASS_NAME, "onReattachedToActivityForConfigChanges==>");
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        LogUtil.i(CLASS_NAME, "onDetachedFromActivityForConfigChanges==>");
        this.onDetachedFromActivity();
    }
}
