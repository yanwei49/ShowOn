//
//  YWCustomTabBarViewController.h
//  ShowOn
//
//  Created by David Yu on 7/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWCustomTabBarViewController;
@protocol YWCustomTabBarViewControllerDelegate <NSObject>

- (void)customTabBarViewControllerDidSelectWithIndex:(NSInteger)index;

@end

@interface YWCustomTabBarViewController : UITabBarController

@property (nonatomic, assign) NSInteger itemNums;
@property (nonatomic, assign) NSInteger itemSelectIndex;
@property (nonatomic, assign) BOOL      hiddenState;
@property (nonatomic, assign) id<YWCustomTabBarViewControllerDelegate> itemDelegate;
@property (nonatomic, strong) NSArray   *imageNames;
@property (nonatomic, strong) NSArray   *selectImageNames;
@property (nonatomic, strong) NSArray   *titles;

@end
