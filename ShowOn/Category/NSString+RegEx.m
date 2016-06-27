//
//  NSString+RegEx.m
//  GoFarm-V1.2.0
//
//  Created by David Yu on 7/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "NSString+RegEx.h"

@implementation NSString (RegEx)

+ (BOOL)isMobilePhone:(NSString *)phone {
    NSString * MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestct evaluateWithObject:phone];
}

+ (BOOL)isPassword:(NSString *)password {
    NSString *nameRegex = @"(\\w{6,16})";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    
    return [nameTest evaluateWithObject:password];
}

+ (BOOL)isIdentityCard:(NSString *)identityCard {
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+(BOOL) validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL) validatePrice:(NSString *)price {
    NSString *emailRegex = @"[0-9]+(\\.[0-9]+)?";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:price];
}

+(BOOL) validatePositiveInteger:(NSString *)integer {
    NSString *emailRegex = @"^[1-9]\\d*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:integer];
}



@end
