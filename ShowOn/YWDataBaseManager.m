//
//  YWDataBaseManager.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/27.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWDataBaseManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "YWUserModel.h"

@interface YWDataBaseManager()

@property (nonatomic, strong) FMDatabaseQueue   *queue;
@property (nonatomic, strong) FMDatabase   *queue1;

@end

@implementation YWDataBaseManager

NSString    *idColunm                             = @"cid";                     //表的主键列ID
/*-----用户表存储字段-----*/
NSString    *loginUserInfosTable                  = @"usersInfoTable";          //登录用户表名
NSString    *userIdColumn                         = @"userId";                  //用户id
NSString    *tokenColumn                          = @"token";                   //token
NSString    *userAaccountColumn                   = @"userAccount";             //用户账号
NSString    *userPasswordColumn                   = @"userPassword";            //用户密码
NSString    *userInfosColumn                      = @"userInfos";               //用户简介
NSString    *userNameColumn                       = @"userName";                //用户昵称
NSString    *userAvatorColumn                     = @"userAvator";              //用户头像


+ (id)shareInstance {
    static YWDataBaseManager *manager;
    if (!manager) {
        manager = [[YWDataBaseManager alloc] init];
    }
    
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/goFarm.db"];
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        //        [self deleteTable:loginUserInfosTable];
        
        //创建登录用户表单
        [self createLoginUserTable];
    }
    
    return self;
}

#pragma mark - delete table
//删除一个表
- (void) deleteTable:(NSString *)tableName {
    [_queue inTransaction:^(FMDatabase *_db, BOOL *rollback) {
        NSString *creatUsersTableSql = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
        if(![_db executeUpdate:creatUsersTableSql])
        {
            DebugLog(@"Could not delete table: %@", [_db lastErrorMessage]);
        }
    }];
}

#pragma mark - 用户表单相关方法
//创建用户表单
- (void)createLoginUserTable {
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (cid integer primary key asc autoincrement, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text, %@ text)", loginUserInfosTable, userIdColumn, tokenColumn, userAaccountColumn, userPasswordColumn, userInfosColumn, userNameColumn, userAvatorColumn];
        //判断创建表单是否成功
        if(![db executeUpdate:sql])
        {
            DebugLog(@"Could not create table: %@", [db lastErrorMessage]);
        }
    }];
}

//添加一个用户
- (void)addLoginUser:(YWUserModel *)user {
    if (user) {
        _loginUser = user;
        [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *insertUser = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?, ?, ?)", loginUserInfosTable, userIdColumn, tokenColumn, userAaccountColumn, userPasswordColumn, userInfosColumn, userNameColumn, userAvatorColumn];
            if (![db executeUpdate:insertUser, user.userId, user.userToken, user.userAccount, user.userPassword, user.userInfos, user.userName, user.portraitUri]) {
                DebugLog(@"Could not insert user: %@", [db lastErrorMessage]);
            }
        }];
    }
}

//更新用户信息
- (void)updateLoginUser:(YWUserModel *)user {
    if (user) {
        [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *updateUser = [NSString stringWithFormat:@"UPDATE %@ set %@ = ?, %@ = ?, %@ = ? , %@ = ? where %@ = ?", loginUserInfosTable, userPasswordColumn, userNameColumn, userInfosColumn, userAvatorColumn, userIdColumn];
            if ([db executeUpdate:updateUser, user.userPassword, user.userName, user.userInfos, user.portraitUri, user.userId]) {
                DebugLog(@"Could not update painting item: %@", [db lastErrorMessage]);
            }else {
                _loginUser = user;
            }
        }];
    }
}

//获取用户表所有信息
- (YWUserModel *)loginUser {
    __block YWUserModel *user;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlFind = [NSString stringWithFormat:@"SELECT * FROM %@", loginUserInfosTable];
        FMResultSet *findResult = [db executeQuery:sqlFind];
        if ([db hadError]) {
            DebugLog(@"Error %d : %@",[db lastErrorCode],[db lastErrorMessage]);
        }else {
            while ([findResult next]) {
                user = [[YWUserModel alloc] init];
                user.userId = [findResult stringForColumn:userIdColumn];
                user.userToken = [findResult stringForColumn:tokenColumn];
                user.userAccount = [findResult stringForColumn:userAaccountColumn];
                user.userPassword = [findResult stringForColumn:userPasswordColumn];
                user.userInfos = [findResult stringForColumn:userInfosColumn];
                user.userName = [findResult stringForColumn:userNameColumn];
                user.portraitUri = [findResult stringForColumn:userAvatorColumn];
            }
        }
    }];
    _loginUser = user;
    return user;
}

//删除用户表所有数据
- (void)cleanLoginUsers {
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *cleanSql = [NSString stringWithFormat:@"DELETE FROM %@", loginUserInfosTable];
        [db executeUpdate:@"UPDATE sqlite_sequence set seq=0 where name='loginUserInfosTable'"];
        if (![db executeUpdate:cleanSql]) {
            DebugLog(@"delete_cate_sql error: %@", [db lastErrorMessage]);
        }
        _loginUser = nil;
    }];
}

//删除用户表的一条数据
- (void)removeUserWithUserId:(NSString *)userId {
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *removeSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@", loginUserInfosTable, userIdColumn, userId];
        if (![db executeUpdate:removeSql]) {
            DebugLog(@"delete user error: %@", [db lastErrorMessage]);
        }
    }];
}



@end
