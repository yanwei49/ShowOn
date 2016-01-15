//
//  YWTrendsModel.h
//  ShowOn
//
//  Created by David Yu on 15/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWMovieModel;
@class YWUserModel;
@interface YWTrendsModel : NSObject

@property (nonatomic, strong) NSString      *trendsId;
@property (nonatomic, strong) NSString      *trendsType;  //(1.自己录制   2.转发)
@property (nonatomic, strong) YWUserModel   *trendsUser;
@property (nonatomic, strong) YWMovieModel  *trendsMovie;

@end
