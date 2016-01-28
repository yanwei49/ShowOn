//
//  YWFocusViewController.h
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@class YWTrendsModel;
@class YWUserModel;
@interface YWTrendsViewController : YWBaseViewController

@property (nonatomic, strong) YWTrendsModel *trends;
@property (nonatomic, strong) YWUserModel *user;

@end
