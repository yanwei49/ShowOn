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
- (void)createRightItemWithImage:(NSString *)imageName;
- (void)actionRightItem:(UIButton *)button;

//跳转到登录页面
- (void)login;

//弹框提示
- (void)showAlterWithTitle:(NSString *)title;

//无内容时界面显示状态
- (void)noContentViewShowWithState:(BOOL)state;

//播放接口（type：1.模板   2.动态）
- (void)requestPlayModelId:(NSString *)modelId withType:(NSInteger)type;

//检测是否是WiFi
- (BOOL)checkNewWorkIsWifi;

@end
