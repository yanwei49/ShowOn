//
//  NSString+Utilities.m
//  GoFarmMerchants-V1.1.0
//
//  Created by David Yu on 2/6/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString *)accordingToAccuracyPriceGiveUpZero {
    NSArray *strs =[self componentsSeparatedByString:@"."];
    if (strs.count == 1) {
        return self;
    }else {
        NSString *str = strs[1];
        for (NSInteger i=0; [str length]; i++) {
            if ([[str substringFromIndex:str.length-1] integerValue]) {
                break;
            }else {
                str = [str substringToIndex:str.length-1];
            }
        }
        if (str.length) {
            return [NSString stringWithFormat:@"%@.%@", strs[0], str];
        }else {
            return strs[0];
        }
    }
}

@end
