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

@property (nonatomic, strong) YWUserModel *movieFirstReleaseUser;//最先发布该视频的用户
@property (nonatomic, strong) YWUserModel *movieReleaseUser;     //发布该视频片段的用户（合作录制时才有值）
@property (nonatomic, strong) NSString    *movieUrl;             //完整视频的url
@property (nonatomic, strong) NSString    *movieName;            //视频名字
@property (nonatomic, strong) NSString    *movieInfos;           //视频简介
@property (nonatomic, strong) NSString    *movieId;              //视频的id
@property (nonatomic, strong) NSString    *moviePlayNumbers;     //视频播放次数
@property (nonatomic, strong) NSString    *movieTimeLength;      //视频时间长度
@property (nonatomic, strong) NSString    *movieReleaseTime;     //视频发布时间
@property (nonatomic, strong) NSString    *movieImageUrl;        //视频封面图的url
@property (nonatomic, strong) NSString    *moviePlayArrayUrl;    //每个视频片段的url数组
@property (nonatomic, strong) NSArray     *moviePlayers;         //发布过该视频的用户数组
@property (nonatomic, strong) NSArray     *movieComments;        //该视频的评论数组
@property (nonatomic, strong) NSString    *movieCollects;        //收藏数
@property (nonatomic, strong) NSString    *movieSupports;        //点赞数
@property (nonatomic, strong) NSString    *movieIsCollect;       //当前登录用户是否藏数（0：未， 1：是）
@property (nonatomic, strong) NSString    *movieIsSupport;       //当前登录用户是否点赞（0：未， 1：是）
@property (nonatomic, strong) NSString    *movieRecorderState;   //视频录制状态（0：未， 1：是）
@property (nonatomic, strong) NSString    *movieRecorderType;    //视频录制时的类型（0：个人录制   1：合作录制   2：转发   3：通告）
@property (nonatomic, strong) NSArray     *movieRecorderUsers;   //合作录制该视频的其他用户数组


@end
