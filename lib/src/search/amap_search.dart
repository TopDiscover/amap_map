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
      final result = await _channel.invokeMethod('searchPOIByKeyword', {
        'keyword': keyword,
        'city': city,
        'page': page,
        'pageSize': pageSize,
      });

      final List<dynamic> list = result['pois'] ?? [];
      return list.map((item) => PoiResult.fromMap(item)).toList();
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
      final result = await _channel.invokeMethod('searchPOINearby', {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'page': page,
        'pageSize': pageSize,
      });

      final List<dynamic> list = result['pois'] ?? [];
      return list.map((item) => PoiResult.fromMap(item)).toList();
    } catch (e) {
      throw Exception('周边搜索失败: $e');
    }
  }
}
