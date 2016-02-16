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

#define Register_Method                       @""         //注册
#define Login_Method                          @""         //登录
#define Reginster_Verification_Method         @""          //注册 获取验证码
#define Reset_Password_Verification_Method    @""          //重置密码 获取验证码
#define Reset_Password_Method                 @""          //重置密码
#define Template_List_Method                  @""          //模板列表
#define Template_Detail_Method                @""          //模板详情
#define Trends_List_Method                    @""          //动态列表
#define Trends_Detail_Method                  @""          //动态详情
#define User_Detail_Method                    @""          //用户详情
#define User_List_Method                      @""          //用户列表
#define Collect_List_Method                   @""          //收藏列表
#define AiTe_List_Method                      @""          //@我列表
#define Comment_List_Method                   @""          //评论列表
#define Support_List_Method                   @""          //点赞列表
#define Draft_List_Method                     @""          //草稿箱列表
#define Support_Method                        @""          //点赞
#define Change_Relation_Type_Method           @""          //修改用户类型


#endif
