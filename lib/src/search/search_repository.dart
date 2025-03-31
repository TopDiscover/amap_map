import './poi_result.dart';
import './amap_search.dart';

class SearchRepository {
  final AmapSearch _amapSearch = AmapSearch();

  // 单例模式
  static final SearchRepository _instance = SearchRepository._internal();

  factory SearchRepository() {
    return _instance;
  }

  SearchRepository._internal();

  Future<List<PoiResult>> searchKeyword(
    String keyword, {
    String city = '',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _amapSearch.searchByKeyword(
        keyword,
        city: city,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      // 可以在这里添加日志记录
      rethrow;
    }
  }

  Future<List<PoiResult>> searchNearby({
    required double latitude,
    required double longitude,
    required int radius,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _amapSearch.searchNearby(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      // 可以在这里添加日志记录
      rethrow;
    }
  }
}
