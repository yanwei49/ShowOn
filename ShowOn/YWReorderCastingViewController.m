//
//  YWReorderCastingViewController.m
//  ShowOn
//
//  Created by David Yu on 6/5/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWReorderCastingViewController.h"
#import "YWEditCoverViewController.h"
#import "YWMovieRecorder.h"
#import "YWMoviePlayView.h"
#import "YWMovieModel.h"
#import "YWUserModel.h"

@interface YWReorderCastingViewController ()<YWMovieRecorderDelegate>

@end

@implementation YWReorderCastingViewController
{
    YWMovieRecorder     *_recorderView;
    YWMoviePlayView     *_downPlayView;
    YWMoviePlayView     *_playView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录制个人简介";
    [self createRightItemWithTitle:@"选择封面"];
    
    [self createSubViews];
}

#pragma mark - subview
- (void)createSubViews {
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    sv.backgroundColor = Subject_color;
    [self.view addSubview:sv];
    sv.contentSize = CGSizeMake(kScreenWidth, 250*3+30);
    
    _playView = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 250) playUrl:_user.casting.movieUrl];
    _playView.backgroundColor = Subject_color;
    _playView.layer.masksToBounds = YES;
    _playView.layer.cornerRadius = 5;
    _playView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
    _playView.layer.borderWidth = 1;
    [sv addSubview:_playView];
    
    _recorderView = [[YWMovieRecorder alloc] initWithFrame:CGRectMake(5, 10+260, kScreenWidth-10, 250)];
    _recorderView.backgroundColor = Subject_color;
    _recorderView.layer.masksToBounds = YES;
    _recorderView.layer.cornerRadius = 5;
    _recorderView.delegate = self;
    _recorderView.movie = _user.casting;
    _recorderView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
    _recorderView.layer.borderWidth = 1;
    [sv addSubview:_recorderView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100, 10, 80, 25)];
    [button setTitle:@"重新录制" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(actionReStart) forControlEvents:UIControlEventTouchUpInside];
    [_recorderView addSubview:button];
    
    _downPlayView = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(5, 15+250*2, kScreenWidth-10, 250) playUrl:@""];
    _downPlayView.backgroundColor = Subject_color;
    _downPlayView.layer.masksToBounds = YES;
    _downPlayView.layer.cornerRadius = 5;
    _downPlayView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
    _downPlayView.layer.borderWidth = 1;
    [sv addSubview:_downPlayView];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    if (_user.casting.movieRecorderUrl) {
        YWEditCoverViewController *vc = [[YWEditCoverViewController alloc] init];
        vc.user = _user;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self showAlterWithTitle:@"请录制视频"];
    }
}

- (void)actionReStart {
    _downPlayView.url = [NSURL URLWithString:@""];
    _user.casting.movieRecorderUrl = nil;
}

#pragma mark - YWMovieRecorderDelegate
- (void)movieRecorderDown:(YWMovieRecorder *)view {
    self.view.userInteractionEnabled = YES;
    _downPlayView.url = view.movie.movieRecorderUrl;
}

- (void)movieRecorderBegin:(YWMovieRecorder *)view {
    self.view.userInteractionEnabled = NO;
}



@end
