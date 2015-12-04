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

#define Register_Method                       @"LoginAndRegister/leaguerRegister?json"      //注册
#define Login_Method                          @"LoginAndRegister/leaguerLogin?json"         //登录
#define Reginster_Verification_Method         @"LoginAndRegister/getAuthCode?json"          //注册 手机获取验证码


#endif
