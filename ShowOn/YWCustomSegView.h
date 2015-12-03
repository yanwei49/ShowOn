//
//  YWCustomSegView.h
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWCustomSegView : UIView

@property (nonatomic, strong) NSArray   *itemTitles;
@property (nonatomic, assign) NSInteger  itemSelectIndex;
@property (nonatomic, strong) UIColor   *backgroundColor;
@property (nonatomic, strong) UIColor   *selectBackgroundColor;
@property (nonatomic, strong) UIColor   *textColor;
@property (nonatomic, strong) UIColor   *selectTextColor;

@end
