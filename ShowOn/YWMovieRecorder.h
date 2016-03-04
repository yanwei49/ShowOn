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
@protocol YWMovieRecorderDelegate <NSObject>

//- (void)movieRecorderDownWithData:(NSData *)data subsectionVideoSort:(NSString *)subsectionVideoSort subsectionVideoType:(NSString *)subsectionVideoType;
- (void)movieRecorderDown:(YWMovieRecorder *)view;
- (void)movieRecorderBegin:(YWMovieRecorder *)view;

@end

@interface YWMovieRecorder : UIView

@property (nonatomic, strong) YWSubsectionVideoModel *model;
//@property (nonatomic, strong) NSString *subsectionVideoSort;
//@property (nonatomic, strong) NSString *subsectionVideoType;
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
