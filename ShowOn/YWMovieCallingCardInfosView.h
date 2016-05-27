//
//  YWMovieCallingCardInfosSView.h
//  ShowOn
//
//  Created by David Yu on 5/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieCardModel;
@class YWUserModel;
@protocol YWMovieCallingCardInfosViewDelegate <NSObject>

- (void)movieCallingCardInfosViewDidSelectPlayButton;
- (void)movieCallingCardInfosViewDidSelectRecorderButton;
- (void)movieCallingCardInfosViewDidSelectSupportButton;

@end

@interface YWMovieCallingCardInfosView : UICollectionReusableView

@property (nonatomic, strong) YWMovieCardModel *model;
@property (nonatomic, strong) YWUserModel *user;
@property (nonatomic, assign) id<YWMovieCallingCardInfosViewDelegate> delegate;
@property (nonatomic, assign) BOOL isEdit;

@end
