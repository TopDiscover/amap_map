import 'package:flutter/services.dart';
import './poi_result.dart';

class AmapSearch {
  static const MethodChannel _channel = MethodChannel('amap_search_channel');

  // 关键字搜索
  Future<List<PoiResult>> searchByKeyword(
    String keyword, {
    /// 搜索超市，空为全国
    String city = '',
    /// poi搜索类型, 如住宅区，学校，医院，楼宇，商场等
    String type = "",
    /// 搜索页
    int page = 1,
    /// 每页大小
    int pageSize = 20,
  }) async {
    try {
      dynamic result = await _channel.invokeMethod('searchPOIByKeyword', {
        "type" : type,
        'keyword': keyword,
        'city': city,
        'page': page,
        'pageSize': pageSize,
      });

      return _toPoiResult(result);
    } catch (e) {
      throw Exception('搜索失败: $e');
    }
  }

  // 周边搜索
  Future<List<PoiResult>> searchNearby({
    /// 纬度
    required double latitude,
    /// 经度
    required double longitude,
    /// 半径 单位：米
    required int radius,
    /// 搜索页
    int page = 1,
    /// 每页大小
    int pageSize = 20,
  }) async {
    try {
      dynamic result = await _channel.invokeMethod('searchPOINearby', {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'page': page,
        'pageSize': pageSize,
      });

      return _toPoiResult(result);
    } catch (e) {
      throw Exception('周边搜索失败: $e');
    }
  }

  _toPoiResult(dynamic result) {
    List<PoiResult> output = <PoiResult>[];
    if (result is List) {
      output = result.map((map) {
        Map<String, dynamic> itemMap = Map<String, dynamic>.from(map);
        return PoiResult.fromMap(itemMap);
      }).toList();
    }
    return output;
  }
}
