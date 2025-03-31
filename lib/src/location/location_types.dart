/// 定位参数设置
class AMapLocationOption {
  /// 是否需要地址信息，默认true
  bool needAddress = true;

  ///逆地理信息语言类型<br>
  ///默认[GeoLanguage.DEFAULT] 自动适配<br>
  ///可选值：<br>
  ///<li>[GeoLanguage.DEFAULT] 自动适配</li>
  ///<li>[GeoLanguage.EN] 英文</li>
  ///<li>[GeoLanguage.ZH] 中文</li>
  GeoLanguage geoLanguage;

  ///是否单次定位
  ///默认值：false
  bool onceLocation = false;

  ///Android端定位模式, 只在Android系统上有效<br>
  ///默认值：[AMapLocationMode.Hight_Accuracy]<br>
  ///可选值：<br>
  ///<li>[AMapLocationMode.Battery_Saving]</li>
  ///<li>[AMapLocationMode.Device_Sensors]</li>
  ///<li>[AMapLocationMode.Hight_Accuracy]</li>
  AMapLocationMode locationMode;

  ///Android端定位间隔<br>
  ///单位：毫秒<br>
  ///默认：2000毫秒<br>
  int locationInterval = 2000;

  ///iOS端是否允许系统暂停定位<br>
  ///默认：false
  bool pausesLocationUpdatesAutomatically = false;

  /// iOS端期望的定位精度， 只在iOS端有效<br>
  /// 默认值：最高精度<br>
  /// 可选值：<br>
  /// <li>[DesiredAccuracy.Best] 最高精度</li>
  /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
  /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
  /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
  /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
  DesiredAccuracy desiredAccuracy = DesiredAccuracy.Best;

  /// iOS端定位最小更新距离<br>
  /// 单位：米<br>
  /// 默认值：-1，不做限制<br>
  double distanceFilter = -1;

  ///iOS 14中设置期望的定位精度权限
  AMapLocationAccuracyAuthorizationMode
      desiredLocationAccuracyAuthorizationMode =
      AMapLocationAccuracyAuthorizationMode.FullAccuracy;

  /// iOS 14中定位精度权限由模糊定位升级到精确定位时，需要用到的场景key fullAccuracyPurposeKey 这个key要和plist中的配置一样
  String fullAccuracyPurposeKey = "";

  AMapLocationOption({
    this.locationInterval = 2000,
    this.needAddress = true,
    this.locationMode = AMapLocationMode.Hight_Accuracy,
    this.geoLanguage = GeoLanguage.DEFAULT,
    this.onceLocation = false,
    this.pausesLocationUpdatesAutomatically = false,
    this.desiredAccuracy = DesiredAccuracy.Best,
    this.distanceFilter = -1,
    this.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.FullAccuracy,
  });

  ///获取设置的定位参数对应的Map
  Map toMap() {
    return {
      "locationInterval": locationInterval,
      "needAddress": needAddress,
      "locationMode": locationMode.index,
      "geoLanguage": geoLanguage.index,
      "onceLocation": onceLocation,
      "pausesLocationUpdatesAutomatically": pausesLocationUpdatesAutomatically,
      "desiredAccuracy": desiredAccuracy.index,
      'distanceFilter': distanceFilter,
      "locationAccuracyAuthorizationMode":
          desiredLocationAccuracyAuthorizationMode.index,
      "fullAccuracyPurposeKey": fullAccuracyPurposeKey,
    };
  }
}

/// 参考：https://amappc.cn-hangzhou.oss-pub.aliyun-inc.com/lbs/static/unzip/Android_Location_Doc/index.html
class AMapLocationResult {
  /// 定位成功
  static final int LOCATION_SUCCESS = 0;

  ///定位结果类型：卫星定位结果<br>
  ///通过设备卫星定位模块返回的定位结果
  static final int LOCATION_TYPE_GPS = 1;

  ///定位结果类型：前次定位结果<br>
  ///网络定位请求低于1秒、或两次定位之间设备位置变化非常小时返回，设备位移通过传感器感知
  static final int LOCATION_TYPE_SAME_REQ = 2;

  ///deprecated
  @Deprecated("此定位类型已废弃，已合并到AMapLocation.LOCATION_TYPE_SAME_REQ")
  static final int LOCATION_TYPE_FAST = 3;

  ///定位结果类型：缓存定位结果<br>
  ///返回一段时间前设备在相同的环境中缓存下来的网络定位结果，节省无必要的设备定位消耗
  static final int LOCATION_TYPE_FIX_CACHE = 4;

  ///定位结果类型：Wifi定位结果<br>
  ///属于网络定位，定位精度相对基站定位会更好
  static final int LOCATION_TYPE_WIFI = 5;

  ///定位结果类型：基站定位结果<br>
  ///通过基站定位返回的定位结果
  static final int LOCATION_TYPE_CELL = 6;

  ///定位结果类型：高德定位结果<br>
  ///通过高德定位返回的定位结果
  static final int LOCATION_TYPE_AMAP = 7;

  ///定位结果类型：离线定位结果<br>
  ///通过离线定位返回的定位结果
  static final int LOCATION_TYPE_OFFLINE = 8;

  ///定位结果类型：最后一次缓存的网络定位结果<br>
  ///通过网络定位返回的定位结果
  static final int LOCATION_TYPE_LAST_LOCATION_CACHE = 9;
  @Deprecated("此定位类型已废弃，官方也没有说明作用")
  static final int LOCATION_COMPENSATION = 10;

  ///定位结果类型：粗略定位结果<br>
  ///粗略定位结果，可能会出现定位偏差，不建议使用
  static final int LOCATION_TYPE_COARSE_LOCATION = 11;

  ///定位结果类型：网络定位结果<br>
  ///通过网络定位返回的定位结果
  static final int LOCATION_TYPE_NETWORK = 12;

  /// 回调时间 格式为"yyyy-MM-dd HH:mm:ss"
  String callbackTime = '';

  /// 定位时间 格式为"yyyy-MM-dd HH:mm:ss"
  String locationTime = '';

  /// 定位类型 具体类型可以参考 定位类型 具体类型可以参考 #AMapLocation.LOCATION_TYPE_*
  int locationType = 0;

  /// 纬度
  double latitude = 0.0;

  /// 经度
  double longitude = 0.0;

  /// 精度 单位:米
  double accuracy = 0.0;

  /// 海拔高度(单位：米) AMapLocation.LOCATION_TYPE_GPS时才有值
  double altitude = 0.0;

  /// 方向(单位：度)，取值范围：【0，360】，其中0度表示正北方向，90度表示正东，180度表示正南，270度表示正西
  double bearing = 0.0;

  /// 速度(单位：米/秒)，AMapLocation.LOCATION_TYPE_GPS时才有值
  double speed = 0.0;

  /// 国家信息
  String country = '';

  /// 省名称 当AMapLocation.LOCATION_TYPE_GPS时也可以返回省名称
  String province = '';

  /// 城市名称 当AMapLocation.LOCATION_TYPE_GPS时也可以返回省城市名称
  String city = '';

  /// 区的名称 当AMapLocation.LOCATION_TYPE_GPS时也可以返回区的名称
  String district = '';

  /// 街道名称 当AMapLocation.LOCATION_TYPE_GPS时也可以返回街道名称
  String street = '';

  /// 门牌号 当AMapLocation.LOCATION_TYPE_GPS时也可以返回门牌号
  String streetNumber = '';

  /// 城市编码
  String cityCode = '';

  /// 区域编码
  String adCode = '';

  /// 地址信息
  String address = '';

  /// 位置语义信息
  String description = '';

  /// 定位错误码
  int errorCode = -1;

  /// 定位错误信息
  String errorInfo = '';

  static AMapLocationResult fromMap(Map<String, dynamic> map) {
    AMapLocationResult location = AMapLocationResult();

    T getValue<T>(String key, T defaultValue) {
      if (map.containsKey(key)) {
        return map[key];
      }
      return defaultValue;
    }

    location.callbackTime = getValue('callbackTime', '');
    location.locationTime = getValue('locationTime', '');
    location.locationType = getValue('locationType', 0);
    location.latitude = getValue('latitude', 0.0);
    location.longitude = getValue('longitude', 0.0);
    location.accuracy = getValue('accuracy', 0.0);
    location.altitude = getValue('altitude', 0.0);
    location.bearing = getValue('bearing', 0.0);
    location.speed = getValue('speed', 0.0);
    location.country = getValue('country', '');
    location.province = getValue('province', '');
    location.city = getValue('city', '');
    location.district = getValue('district', '');
    location.street = getValue('street', '');
    location.streetNumber = getValue('streetNumber', '');
    location.cityCode = getValue('cityCode', '');
    location.adCode = getValue('adCode', '');
    location.address = getValue('address', '');
    location.description = getValue('description', '');
    location.errorCode = getValue('errorCode', -1);
    location.errorInfo = getValue('errorInfo', '');
    return location;
  }

  Map<String, Object> toMap() {
    return {
      "callbackTime": callbackTime,
      "locationTime": locationTime,
      "locationType": locationType,
      "latitude": latitude,
      "longitude": longitude,
      "accuracy": accuracy,
      "altitude": altitude,
      "bearing": bearing,
      "speed": speed,
      "country": country,
      "province": province,
      "city": city,
      "district": district,
      "street": street,
      "streetNumber": streetNumber,
      "cityCode": cityCode,
      "adCode": adCode,
      "address": address,
      "description": description,
      "errorCode": errorCode,
      "errorInfo": errorInfo,
    };
  }

  @override
  String toString() {
    if (errorCode == 0) {
      String result = '''回调时间：$callbackTime
定位时间：$locationTime
定位类型：$locationType
纬度：$latitude
经度：$longitude
精度：$accuracy
海拔高度：$altitude
方向：$bearing
速度：$speed
国家信息：$country
省名称：$province
城市名称：$city
区的名称：$district
街道名称：$street
门牌号：$streetNumber
城市编码：$cityCode
区域编码：$adCode
地址信息：$address
位置语义信息：$description''';
      return result;
    } else {
      String result = '''错误码：$errorCode 
错误信息：$errorInfo''';
      return result;
    }
  }
}

///Android端定位模式
enum AMapLocationMode {
  /// 低功耗模式
  Battery_Saving,

  /// 仅设备模式,不支持室内环境的定位
  Device_Sensors,

  /// 高精度模式
  Hight_Accuracy,
}

///逆地理信息语言
enum GeoLanguage {
  /// 默认，自动适配
  DEFAULT,

  /// 汉语，无论在国内还是国外都返回英文
  ZH,

  /// 英语，无论在国内还是国外都返回中文
  EN,
}

///iOS中期望的定位精度
enum DesiredAccuracy {
  ///最高精度
  Best,

  ///适用于导航场景的高精度
  BestForNavigation,

  ///10米
  NearestTenMeters,

  ///100米
  HundredMeters,

  ///1000米
  Kilometer,

  ///3000米
  ThreeKilometers,
}

///iOS 14中期望的定位精度,只有在iOS 14的设备上才能生效
enum AMapLocationAccuracyAuthorizationMode {
  ///精确和模糊定位
  FullAndReduceAccuracy,

  ///精确定位
  FullAccuracy,

  ///模糊定位
  ReduceAccuracy,
}

///iOS 14中系统的定位类型信息
enum AMapAccuracyAuthorization {
  ///系统的精确定位类型
  AMapAccuracyAuthorizationFullAccuracy,

  ///系统的模糊定位类型
  AMapAccuracyAuthorizationReducedAccuracy,

  ///未知类型
  AMapAccuracyAuthorizationInvalid,
}

abstract class AMapLocationApi {
  /// 适配iOS 14定位新特性，只在iOS平台有效
  Future<AMapAccuracyAuthorization> getSystemAccuracyAuthorization();

  /// 开始定位
  void startLocation();

  /// 停止定位
  void stopLocation();

  ///设置Android和iOS的apikey，建议在weigdet初始化时设置<br>
  ///apiKey的申请请参考高德开放平台官网<br>
  ///Android端: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key<br>
  ///iOS端: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key<br>
  ///[androidKey] Android平台的key<br>
  ///[iosKey] ios平台的key<br>
  void setApiKey(String androidKey, String iosKey);

  /// 设置定位参数
  void setLocationOption(AMapLocationOption option);

  /// 销毁定位
  void destroy();

  ///定位结果回调
  Stream<AMapLocationResult> onLocationChanged();

  /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作<br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy<br>
  /// <b>必须保证在调用定位功能之前调用， 建议首次启动App时弹出《隐私政策》并取得用户同意</b><br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
  /// [hasContains] 隐私声明中是否包含高德隐私政策说明<br>
  /// [hasShow] 隐私权政策是否弹窗展示告知用户<br>
  void updatePrivacyShow(bool hasContains, bool hasShow);

  /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作<br>
  /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy<br>
  /// <b>必须保证在调用定位功能之前调用, 建议首次启动App时弹出《隐私政策》并取得用户同意</b><br>
  /// [hasAgree] 隐私权政策是否已经取得用户同意<br>
  void updatePrivacyAgree(bool hasAgree);
}
