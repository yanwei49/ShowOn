//
//  YWDraftTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWDraftCollectionViewCell.h"
#import "YWTrendsModel.h"
#import "YWMovieModel.h"
#import "YWMovieTemplateModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YWDraftCollectionViewCell
{
    UIImageView   *_imageView;
    UILabel       *_nameLabel;
    UILabel       *_timeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = Subject_color;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = CornerRadius;;

        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(30, 30, 30);
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
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"2015-11-11";
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(0);
            make.height.offset(30);
            make.width.equalTo(80);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"模板名字";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.bottom.offset(0);
            make.height.offset(30);
            make.right.equalTo(_timeLabel.mas_left);
        }];
    }
    
    return self;
}

- (void)setTrends:(YWTrendsModel *)trends {
    _trends = trends;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:trends.trendsMovie.movieCoverImage] placeholderImage:kPlaceholderMoiveImage];
    _nameLabel.text = trends.trendsMovie.movieTemplate.templateName;
    _timeLabel.text = trends.trendsPubdate;
}

@end
