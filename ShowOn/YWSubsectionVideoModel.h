//
//  YWSubsectionVideoModel.h
//  ShowOn
//
//  Created by David Yu on 20/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWUserModel;
@class YWMovieTemplateModel;
@interface YWSubsectionVideoModel : NSObject

@property (nonatomic, strong) NSString *subsectionVideoId;                      //分段视频id
@property (nonatomic, strong) NSString *subsectionVideoUrl;                     //分段视频URL
@property (nonatomic, strong) NSString *subsectionOriginalVideoUrl;             //分段原视频URL
@property (nonatomic, strong) NSString *subsectionVideoTime;                    //分段视频时长
@property (nonatomic, strong) NSURL *recorderVideoUrl;                          //录制完的分段视频URL
@property (nonatomic, strong) NSString *subsectionVideoCoverImage;              //分段视频封面
@property (nonatomic, strong) NSString *subsectionVideoSort;                    //分段视频序号 (处于完整视频中的序号)
@property (nonatomic, strong) NSString *subSort;                                //分段视频子序号
@property (nonatomic, strong) NSString *subsectionVideoType;                    //分段视频类型（ 1、顺序模式(3、近景,4、中景,5、远景,),2、景别模式(6、特写,7、中景,8、远景)）
@property (nonatomic, strong) NSString *subsectionVideoPerformanceStatus;       //分段视频演出状态（0、录制中  1、已演,2、未演）
@property (nonatomic, strong) NSString *subsectionVideoTemplateId;              //分段视频所属模板id
@property (nonatomic, strong) NSString *subsectionVideoPlayUserId;              //分段视频表演用户id


@end
