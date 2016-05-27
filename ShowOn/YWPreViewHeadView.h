//
//  YWPreViewHeadView.h
//  ShowOn
//
//  Created by David Yu on 29/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieCardModel;
@class YWUserModel;
@protocol YWPreViewHeadViewDelegate <NSObject>

- (void)preViewHeadViewDidSelectPlayButton;
- (void)preViewHeadViewDidSelectRecorderButton;
- (void)preViewHeadViewDidSelectSupportButton;

@end
@interface YWPreViewHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame model:(YWMovieCardModel *)model;

@property (nonatomic, strong) YWUserModel *user;
@property (nonatomic, assign) id<YWPreViewHeadViewDelegate> delegate;

@end
