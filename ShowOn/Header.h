//
//  Header.h
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define RK_LOG_ENABLED YES
#define DebugLog( s, ... ) if ( RK_LOG_ENABLED ) NSLog( @"\n\n<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height
#define SeparatorColor   [UIColor colorWithRed:234/256.0 green:234/256.0 blue:234/256.0 alpha:1]
#define RGBColor(r,g,b)  [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]

#define LoginSuccess     @"Login_success"
#define Is480Height      kScreenHeight == 480

//友盟KEY
#define UMengAppKey @"56d91e79e0f55a16240000a1"

//微信appId，appSecret，url
#define WECHAT_APP_ID @"wx6b79801c978776bb"
#define WECHAT_APP_SECRET @"2a58a741210ffdbb6aace788ee1e13c4"
#define WECHAT_APP_URL @"http://www.umeng.com/social"

//QQ appId，appKey，url
#define QQ_APP_ID @"1105153857"
#define QQ_APP_KEY @"jlExH7be6XAlsIVl"
#define QQ_APP_URL @"http://www.umeng.com/social"

//Sina SSO url
#define SINA_SSO_URL @"http://sns.whalecloud.com/sina2/callback"

#define Subject_color    [UIColor colorWithRed:42/256.0 green:42/256.0 blue:42/256.0 alpha:1]
#define CornerRadius     5
#define kPlaceholderUserAvatorImage  [UIImage imageNamed:@"avator_background_image.png"]
#define kPlaceholderMoiveImage  [UIImage imageNamed:@"movie_background_image.jpg"]
#define kPlaceholderArticleImage  [UIImage imageNamed:@"article_background_image.jpg"]


#endif /* Header_h */
