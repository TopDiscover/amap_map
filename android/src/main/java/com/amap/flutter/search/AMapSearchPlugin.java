package com.amap.flutter.search;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.PoiItemV2;
import com.amap.api.services.poisearch.PoiResultV2;
import com.amap.api.services.poisearch.PoiSearchV2;
import com.amap.flutter.map.utils.ConvertUtil;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AMapSearchPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    private Activity activity;
    private PoiSearchV2 poiSearch;

    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "amap_search_channel");
        channel.setMethodCallHandler(this);
        context = binding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        initPrivacy();
    }

    private void initPrivacy() {
        try {
            Map<String,Boolean> map = new HashMap<>();
            map.put("hasContains",true);
            map.put("hasShow",true);
            map.put("hasAgree",true);
            ConvertUtil.setPrivacyStatement(context,map);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        try {
            if (activity == null) {
                result.error("NO_ACTIVITY", "Activity is null", null);
                return;
            }

            switch (call.method) {
                case "searchPOIByKeyword":
                    String keyword = call.argument("keyword");
                    String city = call.argument("city");
                    int page = call.argument("page");
                    int pageSize = call.argument("pageSize");
                    String type = call.argument("type");
                    searchByKeyword(keyword, city,type, page, pageSize, result);
                    break;
                case "searchPOINearby":
                    double latitude = call.argument("latitude");
                    double longitude = call.argument("longitude");
                    int radius = call.argument("radius");
                    int nearbyPage = call.argument("page");
                    int nearbyPageSize = call.argument("pageSize");
                    searchNearby(latitude, longitude, radius, nearbyPage, nearbyPageSize, result);
                    break;
                default:
                    result.notImplemented();
            }
        } catch (AMapException e) {
            result.error("AMAP_ERROR", e.getErrorMessage(), e.getErrorCode());
        } catch (Exception e) {
            result.error("UNEXPECTED_ERROR", e.getMessage(), null);
        }
    }

    private void searchByKeyword(String keyword, String city , String type, int page, int pageSize, MethodChannel.Result result) throws AMapException {
        PoiSearchV2.Query query = new PoiSearchV2.Query(keyword, type, city);
        query.setPageSize(pageSize);
        query.setPageNum(page);

        poiSearch = new PoiSearchV2(activity, query);
        poiSearch.setOnPoiSearchListener(new PoiSearchV2.OnPoiSearchListener() {
            @Override
            public void onPoiSearched(PoiResultV2 poiResult, int errorCode) {
                if (errorCode == 1000) {
                    result.success(convertPoiResult(poiResult));
                } else {
                    result.error("SEARCH_ERROR", "搜索失败: " + errorCode, null);
                }
            }

            @Override
            public void onPoiItemSearched(PoiItemV2 poiItem, int i) {}
        });
        poiSearch.searchPOIAsyn();
    }

    private void searchNearby(double latitude, double longitude, int radius, int page, int pageSize, MethodChannel.Result result) throws AMapException {
        PoiSearchV2.Query query = new PoiSearchV2.Query("", "", "");
        query.setPageSize(pageSize);
        query.setPageNum(page);

        PoiSearchV2.SearchBound searchBound = new PoiSearchV2.SearchBound(
                new LatLonPoint(latitude, longitude), radius);

        poiSearch = new PoiSearchV2(activity, query);
        poiSearch.setBound(searchBound);
        poiSearch.setOnPoiSearchListener(new PoiSearchV2.OnPoiSearchListener() {
            @Override
            public void onPoiSearched(PoiResultV2 poiResult, int errorCode) {
                if (errorCode == 1000) {
                    result.success(convertPoiResult(poiResult));
                } else {
                    result.error("SEARCH_ERROR", "周边搜索失败: " + errorCode, null);
                }
            }

            @Override
            public void onPoiItemSearched(PoiItemV2 poiItem, int i) {}
        });
        poiSearch.searchPOIAsyn();
    }

    private List<Map<String, Object>> convertPoiResult(PoiResultV2 poiResult) {
        List<Map<String, Object>> poiList = new ArrayList<>();

        for (PoiItemV2 poi : poiResult.getPois()) {
            Map<String, Object> poiMap = new LinkedHashMap<>();
            poiMap.put("id", poi.getPoiId());
            poiMap.put("name", poi.getTitle());
            poiMap.put("address", poi.getSnippet());
            poiMap.put("latitude", poi.getLatLonPoint().getLatitude());
            poiMap.put("longitude", poi.getLatLonPoint().getLongitude());
            poiMap.put("district", poi.getAdName());
            poiMap.put("adCode", poi.getAdCode());
            poiMap.put("cityCode", poi.getCityCode());
            poiMap.put("cityName", poi.getCityName());
            poiList.add(poiMap);
        }

        return poiList;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}