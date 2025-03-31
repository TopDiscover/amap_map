#import <Flutter/Flutter.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AMapLocationPlugin : NSObject <FlutterPlugin, AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) FlutterResult locationResult;

@end 