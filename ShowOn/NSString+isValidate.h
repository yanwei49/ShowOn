//
//  NSString+isValidate.h
//  GoFarmApp
//
//  Created by yangchangfu on 15/7/9.
//  Copyright (c) 2015年 唐农网络科技(深圳)有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (isValidate)

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
- (BOOL)isMobileNumber;

+ (BOOL)isValidatePwd:(NSString *)pwd;
-(BOOL)isValidatePassword;

@end
