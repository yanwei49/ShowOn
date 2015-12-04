//
//  YWTranscribeViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTranscribeViewController.h"

@implementation YWTranscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSubViews];
}

- (void)createSubViews {
    UIButton *backButton = [[UIButton alloc] init];
    backButton.backgroundColor = [UIColor whiteColor];
    backButton.layer.cornerRadius = 5;
    backButton.layer.masksToBounds = YES;
    backButton.layer.borderWidth = 1;
    backButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTitle:@"  返回  " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.offset(20);
        make.height.offset(30);
    }];
}

#pragma mark - action
- (void)actionBack:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
