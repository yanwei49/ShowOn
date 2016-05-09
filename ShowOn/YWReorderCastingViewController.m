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

@interface YWReorderCastingViewController ()<YWMovieRecorderDelegate, YWMoviePlayViewDelegate>

@end

@implementation YWReorderCastingViewController
{
    YWMovieRecorder     *_recorderView;
    YWMoviePlayView     *_downPlayView;
    YWMoviePlayView     *_playView;
    UIButton            *_restartButton;
    UIButton            *_changeButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录制个人简介";
    [self createRightItemWithTitle:@"封面"];
    
    [self createSubViews];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_recorderView stopRunning];
    [_playView stop];
    [_downPlayView stop];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_recorderView startRunning];
}

#pragma mark - subview
- (void)createSubViews {
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    sv.backgroundColor = Subject_color;
    [self.view addSubview:sv];
    sv.contentSize = CGSizeMake(kScreenWidth, 250*3+30);
    
    _playView = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 250) playUrl:_user.casting.movieUrl];
    _playView.backgroundColor = Subject_color;
    _playView.layer.masksToBounds = YES;
    _playView.delegate = self;
    _playView.layer.cornerRadius = 5;
    _playView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
    _playView.layer.borderWidth = 1;
    [sv addSubview:_playView];
    
    _recorderView = [[YWMovieRecorder alloc] initWithFrame:CGRectMake(5, 10+250, kScreenWidth-10, 250)];
    _recorderView.backgroundColor = Subject_color;
    _recorderView.layer.masksToBounds = YES;
    _recorderView.layer.cornerRadius = 5;
    _recorderView.delegate = self;
    _recorderView.movie = _user.casting;
    _recorderView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
    _recorderView.layer.borderWidth = 1;
    [sv addSubview:_recorderView];
    
    _restartButton = [[UIButton alloc] init];
    _restartButton.backgroundColor = Subject_color;
    [_restartButton setTitle:@"重新拍摄" forState:UIControlStateNormal];
    [_restartButton setImage:[UIImage imageNamed:@"red_point_button.png"] forState:UIControlStateNormal];
    [_restartButton addTarget:self action:@selector(actionReStart) forControlEvents:UIControlEventTouchUpInside];
    [_recorderView addSubview:_restartButton];
    [_restartButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_recorderView.mas_right).offset(-5);
        make.height.offset(20);
        make.top.equalTo(_recorderView.mas_top).offset(5);
    }];
    
    _changeButton = [[UIButton alloc] init];
    _changeButton.backgroundColor = Subject_color;
    [_changeButton setTitle:@"切换" forState:UIControlStateNormal];
    [_changeButton setImage:[UIImage imageNamed:@"change_shot_button.png"] forState:UIControlStateNormal];
    [_changeButton addTarget:self action:@selector(actionChange:) forControlEvents:UIControlEventTouchUpInside];
    [_recorderView addSubview:_changeButton];
    [_changeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_recorderView.mas_left).offset(5);
        make.height.offset(20);
        make.top.equalTo(_recorderView.mas_top).offset(5);
    }];
    
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

- (void)actionChange:(UIButton *)button {
    [_recorderView changeCamera];
}

#pragma mark - YWMovieRecorderDelegate
- (void)movieRecorderDown:(YWMovieRecorder *)view {
    _changeButton.userInteractionEnabled = YES;
    _restartButton.userInteractionEnabled = YES;
    _downPlayView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    _downPlayView.url = view.movie.movieRecorderUrl;
}

- (void)movieRecorderBegin:(YWMovieRecorder *)view {
    _changeButton.userInteractionEnabled = NO;
    _restartButton.userInteractionEnabled = NO;
    _downPlayView.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [_playView play];
}

#pragma mark - YWMoviePlayViewDelegate
- (void)moviePlayViewPlayDown:(YWMoviePlayView *)view {
    [_recorderView startRecorder];
}


@end
