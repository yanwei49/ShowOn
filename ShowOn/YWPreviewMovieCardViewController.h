//
//  YWPreviewMovieCardViewController.h
//  ShowOn
//
//  Created by David Yu on 9/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@class YWMovieCardModel;
@class YWUserModel;
@interface YWPreviewMovieCardViewController : YWBaseViewController

@property (nonatomic, strong) YWMovieCardModel *model;
@property (nonatomic, strong) YWUserModel *user;

@end
