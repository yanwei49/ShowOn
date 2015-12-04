//
//  YWUserModel.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kBeFocus,         //粉丝
    kFocus,           //关注的人
    kEachOtherFocus,  //相互关注
}FriendRelationType;

@interface YWUserModel : NSObject

@property (nonatomic, strong) NSString  *userId;
@property (nonatomic, strong) NSString  *userAvator;
@property (nonatomic, strong) NSString  *userName;
@property (nonatomic, strong) NSString  *userRank;
@property (nonatomic, strong) NSString  *userEmpirical;                  //经验
@property (nonatomic, strong) NSString  *userAuthentication;             //认证
@property (nonatomic, strong) NSString  *userInfos;                      //简介
@property (nonatomic, strong) NSString  *userFocusNums;                  //关注数
@property (nonatomic, strong) NSString  *userTrendsNums;                 //动态数
@property (nonatomic, strong) NSString  *userFollowsNums;                //粉丝数
@property (nonatomic, strong) NSString  *userCollectNums;                //收藏数
@property (nonatomic, assign) FriendRelationType  userRelationType;      //关系类型


@end
