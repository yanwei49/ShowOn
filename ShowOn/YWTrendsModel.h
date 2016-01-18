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

@property (nonatomic, strong) NSString      *trendsId;                  //动态id
@property (nonatomic, strong) NSString      *trendsType;                //动态类型(1、原创,2、合演,3、转发)
@property (nonatomic, strong) YWUserModel   *trendsUser;                //发布的用户
@property (nonatomic, strong) YWMovieModel  *trendsMovie;               //发布的视频
@property (nonatomic, strong) NSString      *trendsContent;             //发布的文字内容
@property (nonatomic, strong) NSString      *trendsMoviePlayCount;      //发布的视频播放次数
@property (nonatomic, strong) NSString      *trendsForwardComments;     //转发时发布的文字内容

@end
