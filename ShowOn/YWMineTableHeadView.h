//
//  YWMineTableHeadView.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWUserModel;
@class YWMineTableHeadView;
@protocol YWMineTableHeadViewDelegate <NSObject>

@optional
- (void)mineTableHeadViewDidSelectSendMessage;
- (void)mineTableHeadViewDidSelectFocus;
- (void)mineTableHeadViewDidSelectAvator;
@required
- (void)mineTableHeadView:(YWMineTableHeadView *)view didSelectButtonWithIndex:(NSInteger)index;

@end

@interface YWMineTableHeadView : UIView

@property (nonatomic, strong) YWUserModel  *user;
@property (nonatomic, assign) id<YWMineTableHeadViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withUserIsSelf:(BOOL)state;
- (void)reloadFoucsButtonState;

@end
