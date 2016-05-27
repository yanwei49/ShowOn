//
//  YWUserModel.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kEachOtherNoFocus,      //所有用户
    kFocus,                 //关注的人
    kBeFocus,               //粉丝
    kBlackList,             //黑名单
    kEachOtherFocus,        //相互关注
    kWeiboUser              //邀请（微博用户）
}FriendRelationType;

@class YWMovieModel;
@interface YWUserModel : NSObject

@property (nonatomic, strong) NSString  *userId;
@property (nonatomic, strong) NSString  *userType;                       //登陆方式(1、普通帐号,2、QQ,3、微信,4、微博)
@property (nonatomic, strong) NSString  *userAccount;                    //账号
@property (nonatomic, strong) NSString  *userPassword;                   //密码
@property (nonatomic, strong) NSString  *userToken;                      //token
@property (nonatomic, strong) NSString  *portraitUri;                    //头像
@property (nonatomic, strong) NSString  *userSex;                        //1 男，2 女
@property (nonatomic, strong) NSString  *userName;                       //昵称
@property (nonatomic, strong) NSString  *userRank;                       //等级
@property (nonatomic, strong) NSString  *userEmpirical;                  //经验
@property (nonatomic, strong) NSString  *userBirthday;                   //生日
@property (nonatomic, strong) NSString  *userConstellation;              //星座
@property (nonatomic, strong) NSString  *userheight;                     //身高
@property (nonatomic, strong) NSString  *userBwh;                        //三围
@property (nonatomic, strong) NSString  *userAuthentication;             //认证
@property (nonatomic, strong) NSString  *userInfos;                      //简介
@property (nonatomic, strong) NSString  *userDistrict;                   //居住地
@property (nonatomic, strong) NSString  *userFocusNums;                  //关注数
@property (nonatomic, strong) NSString  *userTrendsNums;                 //动态数
@property (nonatomic, strong) NSString  *userFollowsNums;                //粉丝数
@property (nonatomic, strong) NSString  *userCollectNums;                //收藏数
@property (nonatomic, strong) NSString  *userATMeNums;                   //@我的数量
@property (nonatomic, strong) NSString  *userCommentNums;                //评论数
@property (nonatomic, strong) NSString  *userSupportNums;                //点赞数
@property (nonatomic, strong) NSArray   *userTrends;                     //用户动态列表
@property (nonatomic, assign) FriendRelationType  userRelationType;      //关系类型
@property (nonatomic, strong) YWMovieModel *casting;                     //视频简介

@end
