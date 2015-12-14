//
//  YWTemplateCollectionViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTemplateCollectionViewCell.h"

@implementation YWTemplateCollectionViewCell
{
    UIImageView   *_imageView;
    UILabel       *_nameLabel;
    UIView        *_blackView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = Subject_color;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = CornerRadius;;
//        
//        _imageView = [[UIImageView alloc] init];
//        _imageView.backgroundColor = [UIColor greenColor];
//        _imageView.layer.cornerRadius = 30;
//        _imageView.layer.masksToBounds = YES;
//        [self.contentView addSubview:_imageView];
//        [_imageView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(10);
//            make.centerY.equalTo(self.mas_centerY);
//            make.width.height.offset(60);
//        }];
//        
//        _nameLabel = [[UILabel alloc] init];
//        _nameLabel.backgroundColor = [UIColor whiteColor];
//        _nameLabel.font = [UIFont systemFontOfSize:16];
//        [self.contentView addSubview:_nameLabel];
//        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_imageView.mas_centerY);
//            make.left.equalTo(_imageView.mas_right).offset(10);
//            make.height.offset(20);
//        }];
//        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.offset(0);
        }];
        
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = RGBColor(30, 30, 30);
        [self.contentView addSubview:_blackView];
        [_blackView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(30);
        }];

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"明星名字";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(30);
        }];
    }
    
    return self;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _nameLabel.font = textFont;
}

- (void)setViewAlpha:(CGFloat)viewAlpha {
    _viewAlpha = viewAlpha;
    _blackView.alpha = viewAlpha;
}

@end
