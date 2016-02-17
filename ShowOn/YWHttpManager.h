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
 *  获取验证码
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestVerification:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取模板列表
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestTemplateList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取模板详情
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestTemplateDetail:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;


/**
 *  获取动态列表
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestTrendsList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取动态详情
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestTrendsDetail:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取个人资料详情
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestUserDetail:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取用户列表
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestUserList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取收藏列表
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestCollectList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取@我列表
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestAiTeList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取评论列表
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestCommentList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取点赞列表
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestSupportList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  获取草稿箱列表
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestDraftList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  点赞
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestSupport:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  修改用户关系类型
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestChangeRelationType:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  微博好友列表
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestWeiBoFriendList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

/**
 *  搜索
 *
 *  @param parameters 请求参数
 *  @param success    成功block
 *  @param failure    失败block
 */
- (void)requestSearch:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure;

@end
