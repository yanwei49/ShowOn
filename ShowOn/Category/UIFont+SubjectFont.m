//
//  UIFont+SubjectFont.m
//  GoFarm-V1.2.0
//
//  Created by David Yu on 7/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "UIFont+SubjectFont.h"

@implementation UIFont (SubjectFont)

+ (UIFont *)subjectContentFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangHK-Light" size:size];
}

+ (UIFont *)subjectTitleFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"PingFangHK-Semibold" size:size];
}

@end
