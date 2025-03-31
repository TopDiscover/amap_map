package com.amap.flutter.location;

import com.amap.api.location.AMapLocation;

import java.text.SimpleDateFormat;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

public class Utils {
    public static Map<String, Object> buildLocationResultMap(AMapLocation location) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("callbackTime", formatUTC(System.currentTimeMillis()));

        if (location != null) {
            result.put("errorCode", location.getErrorCode());
            if (location.getErrorCode() == AMapLocation.LOCATION_SUCCESS) {
                result.put("locationTime", formatUTC(location.getTime()));
                result.put("locationType", location.getLocationType());
                result.put("latitude", location.getLatitude());
                result.put("longitude", location.getLongitude());
                result.put("accuracy", location.getAccuracy());
                result.put("altitude", location.getAltitude());
                result.put("bearing", location.getBearing());
                result.put("speed", location.getSpeed());
                result.put("country", location.getCountry());
                result.put("province", location.getProvince());
                result.put("city", location.getCity());
                result.put("district", location.getDistrict());
                result.put("street", location.getStreet());
                result.put("streetNumber", location.getStreetNum());
                result.put("cityCode", location.getCityCode());
                result.put("adCode", location.getAdCode());
                result.put("address", location.getAddress());
                result.put("description", location.getDescription());
            } else {
                result.put("errorInfo", location.getErrorInfo() + "|" + location.getLocationDetail());
            }
        } else {
            result.put("errorCode", -1);
            result.put("errorInfo", "location is null");
        }
        return result;
    }

    /**
     * 格式化时间
     *
     * @param time 时间戳
     * @param strPattern 时间格式
     * @return 格式化后的时间字符串
     */
    public static String formatUTC(long time, String strPattern) {
        String pattern = strPattern;
        try {
            return new SimpleDateFormat(pattern, Locale.CHINA).format(time);
        } catch (Throwable e) {
            return "NULL";
        }
    }

    /**
     * 格式化时间，使用默认格式
     *
     * @param time 时间戳
     * @return 格式化后的时间字符串
     */
    public static String formatUTC(long time) {
        return formatUTC(time, "yyyy-MM-dd HH:mm:ss");
    }
}
