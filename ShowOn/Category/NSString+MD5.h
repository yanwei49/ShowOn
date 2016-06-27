//
//  NSString+MD5.h
//  GoFarm-V1.2.0
//
//  Created by David Yu on 7/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

+ (NSString *)md5:(NSString *)originalStr;      //md5加密

@end
