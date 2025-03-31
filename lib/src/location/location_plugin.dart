import 'dart:async';
import 'dart:io';
import './location_types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AMapLocationPlugin {
  final MethodChannel methodChannel =
      const MethodChannel('amap_flutter_location');

  final EventChannel eventChannel =
      const EventChannel('amap_flutter_location_event');

  /// 位置更新流控制器
  StreamController<AMapLocationResult>? _controller;

  /// 位置更新流订阅
  StreamSubscription? _subscription;

  /// 插件key
  String? _pluginKey;

  AMapLocationPlugin() : super() {
    _pluginKey = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void destroy() {
    methodChannel.invokeMethod("destroy", {"pluginKey": _pluginKey});
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
    if (_controller != null) {
      _controller!.close();
      _controller = null;
    }
  }

  Future<AMapAccuracyAuthorization> getSystemAccuracyAuthorization() async {
    int result = -1;
    if (Platform.isIOS) {
      result = await methodChannel.invokeMethod(
        "getSystemAccuracyAuthorization",
        {'pluginKey': _pluginKey},
      );
    }
    if (result == 0) {
      return AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy;
    } else if (result == 1) {
      return AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy;
    }
    return AMapAccuracyAuthorization.AMapAccuracyAuthorizationInvalid;
  }

  Stream<AMapLocationResult> onLocationChanged() {
    if (_controller == null) {
      _controller = StreamController<AMapLocationResult>.broadcast();
      _subscription = eventChannel.receiveBroadcastStream().listen(
        (event) {
          if (event is Map) {
            final map = Map<String, Object>.from(event);
            _controller!.add(AMapLocationResult.fromMap(map));
          }
        },
        onError: (err) {
          _controller!.addError(err);
        },
      );
    }
    return _controller!.stream;
  }

  void setApiKey(String androidKey, String iosKey) {
    methodChannel.invokeMethod("setApiKey", {
      "android": androidKey,
      "ios": iosKey,
    });
  }

  void setLocationOption(AMapLocationOption option) {
    var optionMap = option.toMap();
    optionMap["pluginKey"] = _pluginKey;
    methodChannel.invokeMethod("setLocationOption", optionMap);
  }

  void startLocation() {
    methodChannel.invokeMethod("startLocation", {"pluginKey": _pluginKey});
  }

  void stopLocation() {
    methodChannel.invokeMethod("stopLocation", {"pluginKey": _pluginKey});
  }

  void updatePrivacyAgree(bool hasAgree) {
    methodChannel.invokeMethod("updatePrivacyAgree", {
      "hasAgree": hasAgree,
      "pluginKey": _pluginKey,
    });
  }

  void updatePrivacyShow(bool hasContains, bool hasShow) {
    methodChannel.invokeMethod("updatePrivacyShow", {
      "hasContains": hasContains,
      "hasShow": hasShow,
      "pluginKey": _pluginKey,
    });
  }
}
