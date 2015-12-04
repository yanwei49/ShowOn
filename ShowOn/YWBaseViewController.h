//
//  YWBaseViewController.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWBaseViewController : UIViewController

- (void)createBackLeftItem;
- (void)actionBack:(UIButton *)button;

- (void)createBackRightItemWithTitle:(NSString *)title;
- (void)actionRightItem:(UIButton *)button;

@end
