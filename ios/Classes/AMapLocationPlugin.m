#import "AMapLocationPlugin.h"

@implementation AMapLocationPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:@"com.amap.flutter.map/location"
                                   binaryMessenger:[registrar messenger]];
    AMapLocationPlugin* instance = [[AMapLocationPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"initLocation" isEqualToString:call.method]) {
        [self initLocation:result];
    } else if ([@"getLocation" isEqualToString:call.method]) {
        [self getLocation:result];
    } else if ([@"startLocation" isEqualToString:call.method]) {
        [self startLocation:result];
    } else if ([@"stopLocation" isEqualToString:call.method]) {
        [self stopLocation:result];
    } else if ([@"destroyLocation" isEqualToString:call.method]) {
        [self destroyLocation:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)initLocation:(FlutterResult)result {
    if (!self.locationManager) {
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        self.locationManager.allowsBackgroundLocationUpdates = NO;
        self.locationManager.locationTimeout = 10;
        self.locationManager.reGeocodeTimeout = 5;
    }
    result(nil);
}

- (void)getLocation:(FlutterResult)result {
    self.locationResult = result;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *reGeocode, NSError *error) {
        if (error) {
            result([FlutterError errorWithCode:@"LOCATION_ERROR"
                                     message:error.localizedDescription
                                     details:nil]);
            return;
        }
        
        NSMutableDictionary *locationDict = [NSMutableDictionary dictionary];
        locationDict[@"latitude"] = @(location.coordinate.latitude);
        locationDict[@"longitude"] = @(location.coordinate.longitude);
        locationDict[@"accuracy"] = @(location.horizontalAccuracy);
        locationDict[@"altitude"] = @(location.altitude);
        locationDict[@"speed"] = @(location.speed);
        locationDict[@"bearing"] = @(location.course);
        locationDict[@"timestamp"] = @([location.timestamp timeIntervalSince1970] * 1000);
        
        result(locationDict);
    }];
}

- (void)startLocation:(FlutterResult)result {
    [self.locationManager startUpdatingLocation];
    result(nil);
}

- (void)stopLocation:(FlutterResult)result {
    [self.locationManager stopUpdatingLocation];
    result(nil);
}

- (void)destroyLocation:(FlutterResult)result {
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    result(nil);
}

#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSMutableDictionary *locationDict = [NSMutableDictionary dictionary];
    locationDict[@"latitude"] = @(location.coordinate.latitude);
    locationDict[@"longitude"] = @(location.coordinate.longitude);
    locationDict[@"accuracy"] = @(location.horizontalAccuracy);
    locationDict[@"altitude"] = @(location.altitude);
    locationDict[@"speed"] = @(location.speed);
    locationDict[@"bearing"] = @(location.course);
    locationDict[@"timestamp"] = @([location.timestamp timeIntervalSince1970] * 1000);
    
    [self.channel invokeMethod:@"onLocationChanged" arguments:locationDict];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.locationResult) {
        self.locationResult([FlutterError errorWithCode:@"LOCATION_ERROR"
                                              message:error.localizedDescription
                                              details:nil]);
        self.locationResult = nil;
    }
}

@end 