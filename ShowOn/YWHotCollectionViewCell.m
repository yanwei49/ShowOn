//
//  YWHotCollectionViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHotCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWMovieModel.h"
#import "YWUserModel.h"

@implementation YWHotCollectionViewCell
{
    UIImageView    *_imageView;
    UIImageView    *_avatorImageView;
    UILabel        *_userNameLabel;
    UILabel        *_supportLabel;
    UIButton       *_supportButton;
    UILabel        *_nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = Subject_color;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = CornerRadius;;

        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(70, 70, 70);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(-20);
        }];
        
        UIView  *view = [[UIView alloc] init];
        view.backgroundColor = RGBColor(30, 30, 30);
        [self.contentView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(30);
        }];
        
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.userInteractionEnabled = YES;
        [_avatorImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionAvator)]];
        _avatorImageView.backgroundColor = [UIColor whiteColor];
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.cornerRadius = 30;
        [self.contentView addSubview:_avatorImageView];
        [_avatorImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.bottom.offset(-5);
            make.width.height.offset(60);
        }];
        
        _supportLabel = [[UILabel alloc] init];
        _supportLabel.text = @"0";
        _supportLabel.textColor = [UIColor whiteColor];
        _supportLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_supportLabel];
        [_supportLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-5);
            make.height.offset(20);
            make.bottom.offset(-5);
        }];
        
        _supportButton = [[UIButton alloc] init];
        [_supportButton setImage:[UIImage imageNamed:@"actionbar_location_icon.png"] forState:UIControlStateNormal];
        [_supportButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_supportButton addTarget:self action:@selector(actionSupport:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_supportButton];
        [_supportButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_supportLabel.mas_left).offset(-5);
            make.width.height.offset(20);
            make.centerY.equalTo(_supportLabel.mas_centerY);
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = @"";
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_userNameLabel];
        [_userNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatorImageView.mas_right).offset(5);
            make.right.equalTo(_supportButton.mas_left).offset(-5);
            make.centerY.equalTo(_supportLabel.mas_centerY);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userNameLabel.mas_left);
            make.right.offset(-10);
            make.height.offset(20);
            make.bottom.equalTo(_userNameLabel.mas_top).offset(-5);
        }];
    }
    
    return self;
}

- (void)actionSupport:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(hotCollectionViewCellDidSelectSupport:)]) {
        [_delegate hotCollectionViewCellDidSelectSupport:self];
    }
}

- (void)actionAvator {
    if ([_delegate respondsToSelector:@selector(hotCollectionViewCellDidSelectAvator:)]) {
        [_delegate hotCollectionViewCellDidSelectAvator:self];
    }
}

- (void)setMovie:(YWMovieModel *)movie {
    _movie = movie;
    _nameLabel.text = movie.movieName;
    _supportLabel.text = movie.movieSupports;
    _userNameLabel.text = movie.movieReleaseUser.userName;
    [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:movie.movieReleaseUser.portraitUri] placeholderImage:kPlaceholderUserAvatorImage];
}


@end
