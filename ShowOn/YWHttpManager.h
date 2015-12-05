//
//  YWHttpManager.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWHttpManager : NSObject

//获取单例对象
+ (id)shareInstance;

//取消网络请求
- (void)cancelRequest;

/**
 *  注册
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestRegister:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  登录
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestLogin:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  重置密码
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestResetPassword:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  重置密码获取验证码
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestResetPasswordVerification:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  注册获取验证码
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestRegisterVerification:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;



@end
