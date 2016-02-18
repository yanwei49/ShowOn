//
//  TLHttpGlobalDefine.h
//  GoFarmApp
//
//  Created by David Yu on 7/8/15.
//  Copyright (c) 2015年 唐农网络科技(深圳)有限公司. All rights reserved.
//

#ifndef GoFarmApp_TLHttpGlobalDefine_h
#define GoFarmApp_TLHttpGlobalDefine_h


#define BUNDLE_VERSION                        [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]
#define TIME_OUT                              20
#define VERSION_HEADER                        @"version"

#define Register_Method                       @"juer/user/register?json"         //注册
#define Login_Method                          @"juer/user/login?json"         //登录
#define Verification_Method                   @"juer/user/getVerificationCode?json"          //获取验证码
#define Reset_Password_Method                 @"juer/user/resetPassword?json"          //重置密码
#define Template_List_Method                  @""          //模板列表
#define Template_Detail_Method                @""          //模板详情
#define Trends_List_Method                    @""          //动态列表
#define Trends_Detail_Method                  @""          //动态详情
#define User_Detail_Method                    @"juer/user/getUserInfo?json"          //用户详情
#define User_List_Method                      @"juer/user/getFriendList?json"          //用户列表
#define Collect_List_Method                   @""          //收藏列表
#define AiTe_List_Method                      @""          //@我列表
#define Comment_List_Method                   @""          //评论列表
#define Support_List_Method                   @""          //点赞列表
#define Draft_List_Method                     @""          //草稿箱列表
#define Support_Method                        @"juer/dynamic/praise?json"          //点赞
#define Change_Relation_Type_Method           @"juer/user/updateRelationType?json"          //修改用户类型
#define Search_Method                         @""          //搜索
#define Report_Method                         @"juer/user/inform?json"          //举报
#define Feedback_Method                       @""          //用户反馈
#define Repeat_Method                         @""          //转发
#define Share_Method                          @""          //分享


#endif
