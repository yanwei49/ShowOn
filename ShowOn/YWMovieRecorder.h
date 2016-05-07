//
//  YWMovieRecorder.h
//  ShowOn
//
//  Created by David Yu on 9/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWSubsectionVideoModel;
@class YWMovieRecorder;
@class YWMovieModel;
@protocol YWMovieRecorderDelegate <NSObject>

- (void)movieRecorderDown:(YWMovieRecorder *)view;
- (void)movieRecorderBegin:(YWMovieRecorder *)view;

@end

@interface YWMovieRecorder : UIView

@property (nonatomic, strong) YWSubsectionVideoModel *model;
@property (nonatomic, strong) YWMovieModel *movie;
@property (nonatomic, assign) id<YWMovieRecorderDelegate> delegate;

//激活
- (void)startRunning;

//关闭
- (void)stopRunning;

//开始录制
- (void)startRecorder;

//切换摄像头
- (void)changeCamera;


@end
