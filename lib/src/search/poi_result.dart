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

  factory PoiResult.fromMap(Map<String, dynamic> map) {
    return PoiResult(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      district: map['district'] ?? '',
      adCode: map['adCode'] ?? '',
      cityCode: map['cityCode'] ?? '',
      cityName: map['cityName'] ?? '',
    );
  }
}
