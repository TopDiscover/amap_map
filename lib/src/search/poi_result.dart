class PoiResult {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String district;
  final String adCode;
  final String cityCode;
  final String cityName;

  PoiResult({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.adCode,
    required this.cityCode,
    required this.cityName,
  });

  static PoiResult fromMap(Map<String, dynamic> map) {
    T getValue<T>(String key, T defaultValue) {
      if (map.containsKey(key)) {
        return map[key];
      }
      return defaultValue;
    }

    PoiResult poiResult = PoiResult(
      id: getValue('id', ''),
      name: getValue('name', ''),
      address: getValue('address', ''),
      latitude: getValue('latitude', 0.0),
      longitude: getValue('longitude', 0.0),
      district: getValue('district', ''),
      adCode: getValue('adCode', ''),
      cityCode: getValue('cityCode', ''),
      cityName: getValue('cityName', ''),
    );

    return poiResult;
  }
}
