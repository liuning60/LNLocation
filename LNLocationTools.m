//
//  LNLocationTools.m
//  xcbstudent
//
//  Created by LN-MINI on 2017/4/14.
//  Copyright © 2017年 北京欢乐引擎广告有限公司. All rights reserved.
//

#import "LNLocationTools.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

static LNLocationTools *_locationTools = nil;
@interface LNLocationTools ()<CLLocationManagerDelegate>{
    NSInteger _countSelect;
    NSString *_cityNa;
    NSString *_provinceNa;
}

@property (nonatomic, strong)CLLocation *loc;
@property (strong, nonatomic)CLLocationManager* locationManager;
@end

@implementation LNLocationTools

+(instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationTools = [[LNLocationTools alloc] init];
        
    });
    return _locationTools;
}

-(void)getLocation:(locationBlock)block{
    _countSelect = 0;
    [[LNLocationTools shared] startLocation];
    self.returnBlock = block; // 先赋值block

    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) { // 表示当前禁用了定位功能
        self.returnBlock(@"", @"");
//        // 测试不同地区
//        self.returnBlock(@"上海市", @"上海市");
    }
    
}

-(void)startLocation{
    //1.创建定位管理器
    self.locationManager  = [[CLLocationManager alloc]init];
    //2.开始定位
    [self.locationManager startUpdatingLocation];
    
    //3.设置代理
    self.locationManager.delegate = self;
    
    self.locationManager.distanceFilter=1000.0f;
    
    //4.ios8手动申请用户的授权 (ios6注重隐式 才开始需要申请授权)
    
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.locationManager requestAlwaysAuthorization]; // 永久授权
        [self.locationManager requestWhenInUseAuthorization]; //使用中授权
    }
    
    //5.设置定位数据更新频率(导航专用频率)
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
}
#pragma mark 更新位置的时候调用此方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (_countSelect ==0) {
        CLLocation *loc =   [locations firstObject];
        
        self.loc = loc;
        
        //    获取用户的经纬度
        CLLocationCoordinate2D  coordinate2D = loc.coordinate;
        
        //35.811894   113.459891
        //    coordinate2D.longitude = 113.459891;
        //    coordinate2D.latitude =35.811894;
        //    loc.coordinate = coordinate2D;
        Log(@"当前位置的经纬度:%f  -  %f ",coordinate2D.longitude,coordinate2D.latitude);
        //    if (_i == 0) {
        [self getLocations];
        _countSelect++;
    }
    
}

- (void)getLocations{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //反编码:将当前位置的经纬度数据转换成地理位置名
    [geocoder reverseGeocodeLocation:self.loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = [placemarks lastObject];
        
        NSString *cityName = place.locality;
        NSString *provinceName = place.administrativeArea;
        
        self.returnBlock(provinceName,cityName);
        
        [self.locationManager stopUpdatingLocation];
    }];
    
}

@end
