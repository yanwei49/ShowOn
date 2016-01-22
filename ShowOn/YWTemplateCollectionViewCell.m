//
//  YWTemplateCollectionViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTemplateCollectionViewCell.h"
#import "YWMovieTemplateModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

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

        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = Subject_color;
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
        _nameLabel.text = @"";
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

- (void)setTemplate:(YWMovieTemplateModel *)template {
    _template = template;
    _nameLabel.text = template.templateName;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:template.templateVideoCoverImage] placeholderImage:kPlaceholderMoiveImage];
}


@end
