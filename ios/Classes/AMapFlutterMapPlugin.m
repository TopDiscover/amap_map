#import "AMapFlutterMapPlugin.h"
#import "AMapFlutterFactory.h"
#import "AMapLocationPlugin.h"

@implementation AMapFlutterMapPlugin{
  NSObject<FlutterPluginRegistrar>* _registrar;
  FlutterMethodChannel* _channel;
  NSMutableDictionary* _mapControllers;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    // 注册地图工厂
    AMapFlutterFactory* aMapFactory = [[AMapFlutterFactory alloc] initWithRegistrar:registrar];
    [registrar registerViewFactory:aMapFactory
                            withId:@"com.amap.flutter.map"
  gestureRecognizersBlockingPolicy:
     FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded];
    
    // 注册定位插件
    [AMapLocationPlugin registerWithRegistrar:registrar];
}

@end
