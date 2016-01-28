//
//  YWMovieTemplateModel.h
//  ShowOn
//
//  Created by David Yu on 20/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMovieTemplateModel : NSObject

@property (nonatomic, strong) NSString *templateId;                 //模板id
@property (nonatomic, strong) NSString *templateName;               //模板名称
@property (nonatomic, strong) NSString *templateVideoUrl;           //模板视频URL
@property (nonatomic, strong) NSString *templateVideoTime;          //模板视频长度
@property (nonatomic, strong) NSString *templateVideoCoverImage;    //模板视频封面
@property (nonatomic, strong) NSString *templateTypeId;             //模板类型ID 1、名人专场,2、视频分类,3、应用模版
@property (nonatomic, strong) NSString *templatePlayUserNumbers;    //模板表演的用户数量
@property (nonatomic, strong) NSArray  *templatePlayUsers;          //模板表演的用户
@property (nonatomic, strong) NSArray  *templateSubsectionVideos;   //模板分段视频数组
@property (nonatomic, strong) NSArray  *templateTrends;             //模板视频被表演过的动态数组
@property (nonatomic, strong) NSArray  *templateComments;           //模板评论数组

@end
