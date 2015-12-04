//
//  YWCustomSegView.h
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWCustomSegView;
@protocol YWCustomSegViewDelegate <NSObject>

- (void)customSegView:(YWCustomSegView *)view didSelectItemWithIndex:(NSInteger)index;

@end

@interface YWCustomSegView : UIView

@property (nonatomic, assign) id<YWCustomSegViewDelegate> delegate;

@property (nonatomic, assign) NSInteger  itemSelectIndex;
@property (nonatomic, strong) UIColor   *backgroundColor;
@property (nonatomic, strong) UIColor   *selectBackgroundColor;
@property (nonatomic, strong) UIColor   *textColor;
@property (nonatomic, strong) UIColor   *selectTextColor;
@property (nonatomic, strong) UIFont    *textFont;

- (instancetype)initWithItemTitles:(NSArray *)itemTitles;

@end
