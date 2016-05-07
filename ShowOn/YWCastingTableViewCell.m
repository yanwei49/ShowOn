//
//  YWCastingTableViewCell.m
//  ShowOn
//
//  Created by David Yu on 6/5/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWCastingTableViewCell.h"
#import "YWUserModel.h"
#import "YWDataBaseManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWMovieModel.h"

@implementation YWCastingTableViewCell
{
    UIImageView    *_imageView;
    UIButton       *_playButton;
    UIButton       *_recorderButton;
    UIButton       *_supportButton;
    UILabel        *_supportLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = Subject_color;
        
        UIView  *view = [[UIView alloc] init];
        view.backgroundColor = RGBColor(30, 30, 30);
        [self.contentView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.offset(-10);
        }];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(30, 30, 30);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [view addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(-40);
        }];
        
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_playButton];
        [_playButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imageView.mas_centerY);
            make.centerX.equalTo(_imageView.mas_centerX);
            make.width.height.offset(80);
        }];
        
        _recorderButton = [[UIButton alloc] init];
        [_recorderButton setTitle:@"重新拍摄" forState:UIControlStateNormal];
        _recorderButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_recorderButton addTarget:self action:@selector(actionRecorder:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_recorderButton];
        [_recorderButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.height.offset(30);
            make.bottom.offset(-5);
            make.width.offset(80);
        }];
        
        _supportLabel = [[UILabel alloc] init];
        _supportLabel.text = @"0";
        _supportLabel.textAlignment = NSTextAlignmentCenter;
        _supportLabel.textColor = [UIColor whiteColor];
        _supportLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:_supportLabel];
        [_supportLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.height.offset(20);
            make.bottom.offset(-10);
            make.width.offset(25);
        }];

        _supportButton = [[UIButton alloc] init];
        [_supportButton setImage:[UIImage imageNamed:@"support_normal.png"] forState:UIControlStateNormal];
        [_supportButton setImage:[UIImage imageNamed:@"support_selected.png"] forState:UIControlStateSelected];
        [_supportButton addTarget:self action:@selector(actionSupport:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_supportButton];
        [_supportButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_supportLabel.mas_left);
            make.height.width.offset(20);
            make.bottom.offset(-10);
        }];
    }
    
    return self;
}

- (void)actionPlay:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(castingTableViewCellDidSelectPlayButton)]) {
        [_delegate castingTableViewCellDidSelectPlayButton];
    }
}

- (void)actionRecorder:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(castingTableViewCellDidSelectRecorderButton)]) {
        [_delegate castingTableViewCellDidSelectRecorderButton];
    }
}

- (void)actionSupport:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(castingTableViewCellDidSelectSupportButton)]) {
        [_delegate castingTableViewCellDidSelectSupportButton];
    }
}

#pragma mark - get set
- (void)setUser:(YWUserModel *)user {
    _user = user;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:user.casting.movieCoverImage] placeholderImage:kPlaceholderMoiveImage];
    _recorderButton.hidden = ([user.userId isEqualToString:[[YWDataBaseManager shareInstance] loginUser].userId])?NO:YES;
    _supportLabel.text = user.casting.movieSupports.length?user.casting.movieSupports:@"0";
    _supportButton.selected = user.casting.movieIsSupport.integerValue?YES:NO;
}


@end
