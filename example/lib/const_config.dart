import 'package:x_amap_base/x_amap_base.dart';

class ConstConfig {
  static const AMapApiKey amapApiKeys = AMapApiKey(
      androidKey: 'd7eef7eabad2ecc7d2ab31c56f6bf9cc',
      iosKey: '4dfdec97b7bf0b8c13e94777103015a9');
  static const AMapPrivacyStatement amapPrivacyStatement =
      AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);
}
