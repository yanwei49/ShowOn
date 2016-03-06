//
//  YWCutImageViewController.m
//  ShowOn
//
//  Created by 颜魏 on 16/3/5.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWCutImageViewController.h"
#import "YWTools.h"

@interface YWCutImageViewController ()

@end

@implementation YWCutImageViewController
{
    UIView          *_cutView;
    UIImageView     *_imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自拍海报裁剪";
    [self createRightItemWithTitle:@"裁剪"];
    
    [self createSubViews];
}

- (void)createSubViews {
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = Subject_color;
    _imageView.image = _image;
    [self.view addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.offset(kScreenWidth*0.8);
    }];
    
    _cutView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, kScreenHeight/2-100, 200, 200)];
    _cutView.backgroundColor = [UIColor lightGrayColor];
    [_cutView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPan:)]];
    _cutView.alpha = 0.5;
    [self.view addSubview:_cutView];
}

- (void)obtainCutImage {
    UIImage *cutImage = [YWTools cutImage:_image withRect:_cutView.frame];
    if ([_delegate respondsToSelector:@selector(cutImageViewControllerCutImage:)]) {
        [_delegate cutImageViewControllerCutImage:cutImage];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    [self obtainCutImage];
}

- (void)actionPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
}


@end
