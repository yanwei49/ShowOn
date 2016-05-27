//
//  YWEditMovieCallingCardViewController.h
//  ShowOn
//
//  Created by David Yu on 5/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@class YWMovieCardModel;
@class YWUserModel;
@interface YWEditMovieCallingCardViewController : YWBaseViewController

@property (nonatomic, strong) YWMovieCardModel *mc;
@property (nonatomic, strong) YWUserModel *user;

@end
