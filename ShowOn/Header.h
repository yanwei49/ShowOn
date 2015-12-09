//
//  Header.h
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height
#define SeparatorColor   [UIColor colorWithRed:234/256.0 green:234/256.0 blue:234/256.0 alpha:1]
#define RGBColor(r,g,b)  [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]
#define LoginSuccess     @"Login_success"
#define Is480Height      kScreenHeight == 480

//友盟KEY
#define YOUMENG_API_KEY @"54602473fd98c50587000692"
#define GAODE_API_KEY @"9098ae519a1257ed1c61415aa9cae45b"

//微信appId，appSecret，url
#define WECHAT_APP_ID @"wxe0812af07356c373"
#define WECHAT_APP_SECRET @"470d32383ad311964ee6261ff161de7e"
#define WECHAT_APP_URL @"http://www.triphare.com"

//QQ appId，appKey，url
#define QQ_APP_ID @"1103447933"
#define QQ_APP_KEY @"4zYnK0dIpDbFTuE"
#define QQ_APP_URL @"http://www.triphare.com"

//Sina SSO url
#define SINA_SSO_URL @"http://sns.whalecloud.com/sina2/callback"

#endif /* Header_h */
