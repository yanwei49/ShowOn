//
//  YWMovieModel.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/16.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWMovieTemplateModel;
@interface YWMovieModel : NSObject

@property (nonatomic, strong) NSString  *movieId;                       //视频id
@property (nonatomic, strong) NSString  *movieUrl;                      //视频URL
@property (nonatomic, strong) NSString  *movieName;                     //视频名称
@property (nonatomic, strong) NSString  *movieCoverImage;               //视频封面
@property (nonatomic, strong) NSString  *movieIsSupport;                //视频是否点赞
@property (nonatomic, strong) NSString  *movieSupports;                 //视频点赞数
@property (nonatomic, strong) NSURL  *movieRecorderUrl;              //录制好的视频URL
@property (nonatomic, strong) YWMovieTemplateModel  *movieTemplate;     //视频的模板

@end
