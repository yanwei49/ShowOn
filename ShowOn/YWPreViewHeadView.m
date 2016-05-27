//
//  YWPreViewHeadView.m
//  ShowOn
//
//  Created by David Yu on 29/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWPreViewHeadView.h"
#import "YWMovieCardModel.h"
#import "YWUserModel.h"
#import "YWDataBaseManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWMovieModel.h"

@interface YWPreViewHeadView()<UITextFieldDelegate>

@end

@implementation YWPreViewHeadView
{
    NSMutableArray      *_tfs;
    UIImageView    *_imageView;
    UIButton       *_playButton;
    UIButton       *_recorderButton;
    UIButton       *_supportButton;
    UILabel        *_supportLabel;
}

- (instancetype)initWithFrame:(CGRect)frame model:(YWMovieCardModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBColor(50, 50, 50);
        [self addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(60);
        }];
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.backgroundColor = RGBColor(50, 50, 50);
        imageView1.image = [UIImage imageNamed:@"juer_.png"];
        [view addSubview:imageView1];
        [imageView1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.height.offset(60);
            make.width.offset(80);
        }];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = RGBColor(50, 50, 50);
        imageView.image = [UIImage imageNamed:@"juer_title.png"];
        [view addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(-15);
            make.left.offset(85);
            make.height.offset(60);
            make.width.offset(150);
        }];

        UIView  *view1 = [[UIView alloc] init];
        view1.backgroundColor = RGBColor(50, 50, 50);
        [self addSubview:view1];
        [view1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(65);
            make.left.right.offset(0);
            make.height.offset(195);
        }];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(42, 42, 42);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [view1 addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(-40);
        }];
        
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:_playButton];
        [_playButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imageView.mas_centerY);
            make.centerX.equalTo(_imageView.mas_centerX);
            make.width.height.offset(80);
        }];
        
        _recorderButton = [[UIButton alloc] init];
        [_recorderButton setTitle:@"重新拍摄" forState:UIControlStateNormal];
        _recorderButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_recorderButton addTarget:self action:@selector(actionRecorder:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:_recorderButton];
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
        [view1 addSubview:_supportLabel];
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
        [view1 addSubview:_supportButton];
        [_supportButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_supportLabel.mas_left);
            make.height.width.offset(20);
            make.bottom.offset(-10);
        }];
        
        _tfs = [[NSMutableArray alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = Subject_color;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.text = @"姓名:";
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(260);
            make.height.offset(40);
            make.left.equalTo(10);
            make.width.offset(40);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.backgroundColor = Subject_color;
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = [UIColor whiteColor];
        label1.text = model.authentication;
        [self addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label.mas_centerY);
            make.height.offset(30);
            make.left.equalTo(label.mas_right).offset(5);
            make.right.offset(0);
        }];
        NSArray *titles;
        NSArray *contents;
        if (model.address.length && model.constellation.length) {
            titles = @[@"地区:", @"年龄:", @"星座:", @"身高:"];
            contents = @[model.address, model.age, model.constellation, model.height];
        }else if (model.address.length) {
            titles = @[@"地区:", @"年龄:", @"身高:"];
            contents = @[model.address, model.age, model.height];
        }else if (model.constellation.length) {
            titles = @[@"地区:", @"年龄:", @"星座:"];
            contents = @[model.address, model.age, model.constellation];
        }else {
            titles = @[@"地区:", @"年龄:"];
            contents = @[model.address, model.age];
        }
        UILabel *lastLabel;
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = Subject_color;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            label.text = titles[i];
            [self addSubview:label];
            lastLabel = label;
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(300+40*(i/2));
                make.height.offset(40);
                make.left.equalTo(kScreenWidth/2*(i%2)+10);
                make.width.offset(40);
            }];
            
            UILabel *label1 = [[UILabel alloc] init];
            label1.backgroundColor = Subject_color;
            label1.font = [UIFont systemFontOfSize:14];
            label1.textColor = [UIColor whiteColor];
            label1.text = contents[i];
            [self addSubview:label1];
            [label1 makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label.mas_centerY);
                make.height.offset(30);
                make.left.equalTo(label.mas_right).offset(5);
                make.right.offset(kScreenWidth/2*(i%2-1));
            }];
        }
        
        NSMutableArray *titles1 = [NSMutableArray array];
        NSMutableArray *contents1 = [NSMutableArray array];
        [titles1 addObject:@"三围:"];
        [contents1 addObject:model.bwh];
        if (model.announce.length) {
            [titles1 addObject:@"通告:"];
            [contents1 addObject:model.announce];
        }
        [titles1 addObject:@"邮箱:"];
        [contents1 addObject:model.email];
        if (model.info.length) {
            [titles1 addObject:@"简介:"];
            [contents1 addObject:model.info];
        }
        CGFloat h = 340;
        if (titles.count>2) {
            h += 40;
        }
        for (NSInteger i=0; i<titles1.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = Subject_color;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            label.text = titles1[i];
            [view addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(h+i*40);
                make.height.offset(40);
                make.left.equalTo(10);
                make.width.offset(40);
            }];
            
            UILabel *label1 = [[UILabel alloc] init];
            label1.backgroundColor = Subject_color;
            label1.font = [UIFont systemFontOfSize:14];
            label1.textColor = [UIColor whiteColor];
            label1.text = contents1[i];
            [view addSubview:label1];
            [label1 makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label.mas_centerY);
                make.height.offset(30);
                make.left.equalTo(label.mas_right).offset(5);
                make.right.offset(0);
            }];
        }
    }
    
    return self;
}

#pragma mark - action
- (void)actionPlay:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(preViewHeadViewDidSelectPlayButton)]) {
        [_delegate preViewHeadViewDidSelectPlayButton];
    }
}

- (void)actionRecorder:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(preViewHeadViewDidSelectRecorderButton)]) {
        [_delegate preViewHeadViewDidSelectRecorderButton];
    }
}

- (void)actionSupport:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(preViewHeadViewDidSelectSupportButton)]) {
        [_delegate preViewHeadViewDidSelectSupportButton];
    }
}

#pragma mark - get set
- (void)setUser:(YWUserModel *)user {
    _user = user;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:user.casting.movieCoverImage?:@""] placeholderImage:kPlaceholderMoiveImage];
    _recorderButton.hidden = ([user.userId isEqualToString:[[YWDataBaseManager shareInstance] loginUser].userId])?NO:YES;
    _supportLabel.text = user.casting.movieSupports.length?user.casting.movieSupports:@"0";
    _supportButton.selected = user.casting.movieIsSupport.integerValue?YES:NO;
}


@end
