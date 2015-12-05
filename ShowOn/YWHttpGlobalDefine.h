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


#endif
