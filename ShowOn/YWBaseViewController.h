//
//  YWBaseViewController.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWBaseViewController : UIViewController

- (void)createLeftItemWithTitle:(NSString *)title;
- (void)actionLeftItem:(UIButton *)button;

- (void)createRightItemWithTitle:(NSString *)title;
- (void)actionRightItem:(UIButton *)button;

- (void)createRightItemWithImage:(NSString *)imageName;
//跳转到登录页面
- (void)login;

@end
