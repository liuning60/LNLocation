//
//  LNLocationTools.h
//  xcbstudent
//
//  Created by LN-MINI on 2017/4/14.
//  Copyright © 2017年 北京欢乐引擎广告有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^locationBlock)(NSString *city, NSString *province);

@interface LNLocationTools : NSObject

+ (instancetype)shared;

@property (nonatomic, copy) locationBlock returnBlock;

-(void)getLocation:(locationBlock)block;

@end
