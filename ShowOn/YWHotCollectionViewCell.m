//
//  YWHotCollectionViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHotCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(-20);
        }];
        
        UIImageView *playImageView = [[UIImageView alloc] init];
        playImageView.backgroundColor = [UIColor greenColor];
        playImageView.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:playImageView];
        [playImageView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_imageView.center);
            make.width.height.offset(40);
        }];
        
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_avatorImageView];
        [_avatorImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.bottom.offset(-25);
            make.width.offset(40);
            make.height.offset(30);
        }];
        
        _supportLabel = [[UILabel alloc] init];
        _supportLabel.backgroundColor = [UIColor whiteColor];
        _supportLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_supportLabel];
        [_supportLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-5);
            make.height.offset(15);
            make.centerY.equalTo(_avatorImageView.mas_centerY);
        }];
        
        _supportButton = [[UIButton alloc] init];
        _supportButton.backgroundColor = [UIColor whiteColor];
        [_supportButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_supportButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_supportButton addTarget:self action:@selector(actionSupport:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_supportButton];
        [_supportButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_supportLabel.mas_left).offset(-5);
            make.width.height.offset(20);
            make.centerY.equalTo(_avatorImageView.mas_centerY);
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = [UIColor whiteColor];
        _userNameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_userNameLabel];
        [_userNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatorImageView.mas_right).offset(5);
            make.right.equalTo(_supportButton.mas_left).offset(-5);
            make.centerY.equalTo(_avatorImageView.mas_centerY);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor yellowColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(20);
        }];
    }
    
    return self;
}

- (void)actionSupport:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(hotCollectionViewCellDidSelectSupport:)]) {
        [_delegate hotCollectionViewCellDidSelectSupport:self];
    }
}

@end
