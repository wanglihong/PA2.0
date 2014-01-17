//
//  Tools.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-11.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSString *)dateWithDate:(NSString *)dateString;

+ (NSString *)timeWithDate:(NSString *)dateString;

+ (NSString *)dateStringWithDate:(NSDate *)date;

+ (void)fadeIn:(UIView *)view duration:(float)duration;

+ (void)alertWithTitle:(NSString *)title;

+ (void)pushView:(UIView*)v1 fromView:(UIView*)v2 onView:(UIView*)cv;

+ (void)revealView:(UIView*)v1 fromView:(UIView*)v2 onView:(UIView*)cv;

@end
