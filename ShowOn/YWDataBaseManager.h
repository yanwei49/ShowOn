//
//  YWDataBaseManager.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/27.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWUserModel;
@interface YWDataBaseManager : NSObject

@property (nonatomic, strong) YWUserModel *loginUser;

//获取单例对象
+ (id)shareInstance;

/**
 *  增加一个登录用户到数据库
 *
 *  @param user 用户
 */
-(void) addLoginUser:(YWUserModel *) user;

/**
 *  更新用户数据
 *
 *  @param user 用户
 */
-(void) updateLoginUser:(YWUserModel *) user;

/**
 *  清除所有用户
 */
-(void) cleanLoginUsers;


@end
