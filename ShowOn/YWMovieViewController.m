//
//  YWMovieViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWMovieViewController.h"
#import "AppDelegate.h"

@interface YWMovieViewController ()

@end

@implementation YWMovieViewController
{
    UIView      *_tooBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;

    [self createSubViews];
}

- (void)createSubViews {
    _tooBar = [[UIView alloc] init];
    _tooBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tooBar];
    [_tooBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(60);
    }];
    
    UIView  *lineView = [[UIView alloc] init];
    lineView.backgroundColor = SeparatorColor;
    [_tooBar addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(1);
    }];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.backgroundColor = [UIColor whiteColor];
    backButton.layer.cornerRadius = 5;
    backButton.layer.masksToBounds = YES;
    backButton.layer.borderWidth = 1;
    backButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTitle:@"    返回    " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    [_tooBar addSubview:backButton];
    [backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tooBar.mas_centerY);
        make.left.offset(20);
        make.height.offset(30);
    }];
    
    UIButton *takePhotoButton = [[UIButton alloc] init];
    takePhotoButton.backgroundColor = [UIColor redColor];
    takePhotoButton.layer.cornerRadius = 20;
    takePhotoButton.layer.masksToBounds = YES;
    [takePhotoButton addTarget:self action:@selector(actionTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_tooBar addSubview:takePhotoButton];
    [takePhotoButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tooBar.mas_centerY);
        make.centerX.equalTo(_tooBar.mas_centerX);
        make.height.offset(40);
        make.width.offset(40);
    }];
}

#pragma mark - action
- (void)actionBack:(UIButton *)button {
    AppDelegate *application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [application movieVCToBack];
}

- (void)actionTakePhoto:(UIButton *)button {
    
}



@end
