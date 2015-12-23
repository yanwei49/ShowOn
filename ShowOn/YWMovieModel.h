//
//  YWMovieModel.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/16.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWUserModel;
@interface YWMovieModel : NSObject

@property (nonatomic, strong) YWUserModel *user;            //发布的用户
@property (nonatomic, strong) NSString    *url;             //完整视频的url
@property (nonatomic, strong) NSString    *movieId;         //视频的id
@property (nonatomic, strong) NSString    *imageUrl;        //视频封面的url
@property (nonatomic, strong) NSString    *playArrayUrl;    //每个视频片段的url数组


@end
