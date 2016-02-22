//
//  YWMoviePlayView.h
//  ShowOn
//
//  Created by David Yu on 9/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMoviePlayView;
@protocol YWMoviePlayViewDelegate <NSObject>

- (void)moviePlayViewPlayWithState:(BOOL)playState;
- (void)moviePlayViewPlayDown:(YWMoviePlayView *)view;

@end

@interface YWMoviePlayView : UIView

@property (nonatomic, assign) BOOL playButtonHiddenState;
@property (nonatomic, assign) id<YWMoviePlayViewDelegate> delegate;
@property (nonatomic, strong) NSString *urlStr;  //开始播放知指定URL的视频
@property (nonatomic, assign) BOOL isCountdown;  //是否开启倒计时

- (instancetype)initWithFrame:(CGRect)frame playUrl:(NSString *)url;

////播放
//- (void)play;

//停止
- (void)stop;

@end
