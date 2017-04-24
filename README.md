# LNLocation
获取用户所在省市


1.需要在info.plist里添加NSLocationWhenInUseUsageDescription值，否则不能运行


2.模拟器运行时，mac pro/air 等笔记本模拟器无法获取定位，mac mini可用模拟器获得定位（洛杉矶）


3.引入#import <CoreLocation/CoreLocation.h>
      #import <MapKit/MapKit.h>
      #import "LNLocationTools.h" 


4.调用方法


    LNLocationTools *tools = [LNLocationTools shared] ;
    
    
    [tools getLocation:^(NSString *city, NSString *province) {
    
    
        //在这里处理回调
        
        //返回值 city、province
        
        //如果需要更多详细信息，如：街道、国家等，请修改返回值，或联系442081456@qq.com
        
        
        
    }];
