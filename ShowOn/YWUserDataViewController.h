//
//  YWUserDataViewController.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@class YWUserModel;
@interface YWUserDataViewController : YWBaseViewController

@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, strong) YWUserModel *user;

@end
