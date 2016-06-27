//
//  NSString+RegEx.h
//  GoFarm-V1.2.0
//
//  Created by David Yu on 7/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegEx)

+ (BOOL)isMobilePhone:(NSString *)phone;            //检测是否是手机
+ (BOOL)isPassword:(NSString *)password;            //检测是否符合密码规则
+ (BOOL)isIdentityCard:(NSString *)identityCard;    //检测是否是身份证
+ (BOOL)validateEmail:(NSString *)email;            //检测是否是邮箱
+ (BOOL)validatePrice:(NSString *)price;            //检测是否是价格
+ (BOOL)validatePositiveInteger:(NSString *)integer;//检测正整数

@end
