//
//  TLFriendListManager.m
//  GoFarmApp
//
//  Created by David Yu on 26/8/15.
//  Copyright (c) 2015年 唐农网络科技(深圳)有限公司. All rights reserved.
//

#import "YWFriendListManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "YWHttpManager.h"
#import "YWDataBaseManager.h"
#import "YWUserModel.h"
#import "YWParser.h"
#import <RongIMKit/RongIMKit.h>

@interface YWFriendListManager()<RCIMUserInfoDataSource>

@end

@implementation YWFriendListManager
{
    YWHttpManager                 *_httpManager;
    YWDataBaseManager             *_dataBaseManager;
    NSArray                       *_userList;
}

+ (id)shareInstance {
    static YWFriendListManager * manager;
    if (!manager) {
        manager = [[YWFriendListManager alloc] init];
        [manager requestFriendList];
    }
    
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        _dataBaseManager = [YWDataBaseManager shareInstance];
        _httpManager = [YWHttpManager shareInstance];
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
    }
    
    return self;
}

- (void)requestFriendList {
    if ([[YWDataBaseManager shareInstance] loginUser].userId) {
        NSDictionary *parameters = @{@"relationTypeId": @(0), @"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"page": @(0)};
        [_httpManager requestUserList:parameters success:^(id responseObject) {
            YWParser *parser = [[YWParser alloc] init];
            _userList = [parser userWithArray:[responseObject objectForKey:@"userList"]];
        } otherFailure:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 融云相关
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    if ([userId isEqualToString:[[YWDataBaseManager shareInstance] loginUser].userAccount]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = [[YWDataBaseManager shareInstance] loginUser].userId;
        user.name = [[YWDataBaseManager shareInstance] loginUser].userName;
        user.portraitUri = [[YWDataBaseManager shareInstance] loginUser].portraitUri;
        
        return completion(user);
    }else {
        for (YWUserModel *model in _userList) {
            if ([model.userAccount isEqualToString:userId]) {
                RCUserInfo *user = [[RCUserInfo alloc]init];
                user.userId = model.userAccount;
                user.name = model.userName;
                user.portraitUri = model.portraitUri;
                
                return completion(user);
            }
        }
    }
}

@end


