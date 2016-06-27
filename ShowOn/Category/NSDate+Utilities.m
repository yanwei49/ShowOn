//
//  NSDate+Utilities.m
//  GoFarm-V1.2.0
//
//  Created by David Yu on 14/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

+ (NSTimeInterval)dateWithCurrentTimeSeconds:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *currentDate = [date dateByAddingTimeInterval:interval];
    NSDate *futureDate1 = [formatter dateFromString:dateString];
    NSDate *futureDate = [futureDate1 dateByAddingTimeInterval:interval];
    NSTimeInterval time=[futureDate timeIntervalSinceDate:currentDate];
    
    return time;
}

+ (NSString *)dateStringWithDate:(NSDate *)date {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormat stringFromDate:date];
    
}

+ (NSDate *)dateWithDateString:(NSString *)dateString {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormat setTimeZone:timeZone];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormat dateFromString:dateString];
}

@end
