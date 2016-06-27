//
//  NSDate+Utilities.h
//  GoFarm-V1.2.0
//
//  Created by David Yu on 14/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)

+ (NSTimeInterval)dateWithCurrentTimeSeconds:(NSString *)dateString;

+ (NSString *)dateStringWithDate:(NSDate *)date;

+ (NSDate *)dateWithDateString:(NSString *)dateString;

@end
