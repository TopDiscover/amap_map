import 'package:flutter/services.dart';
import './poi_result.dart';

class AmapSearch {
  static const MethodChannel _channel = MethodChannel('amap_search_channel');

  // 关键字搜索
  Future<List<PoiResult>> searchByKeyword(
    String keyword, {
    String city = '',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      dynamic result = await _channel.invokeMethod('searchPOIByKeyword', {
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
    required double latitude,
    required double longitude,
    required int radius,
    int page = 1,
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
