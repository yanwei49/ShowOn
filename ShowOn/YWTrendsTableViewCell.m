//
//  YWTrendsTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTrendsTableViewCell.h"
//#import "YWMoviePlayView.h"
#import "YWTrendsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWMovieTemplateModel.h"
#import "YWMovieModel.h"

@implementation YWTrendsTableViewCell
{
//    YWMoviePlayView   *_playMovie;
    UILabel           *_contentLabel;
    UIButton          *_supportButton;
    UILabel           *_supportLabel;
    UILabel           *_timeLabel;
    UIImageView       *_imageView;
    UIButton          *_playingButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(30, 30, 30);
        
//        _playMovie = [[YWMoviePlayView alloc] init];
//        _playMovie.backgroundColor = Subject_color;
//        _playMovie.layer.masksToBounds = YES;
//        _playMovie.layer.cornerRadius = 5;
//        [self.contentView addSubview:_playMovie];
//        [_playMovie makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.offset(5);
//            make.right.offset(-5);
//            make.height.offset(200);
//        }];
//        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(30, 30, 30);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(5);
            make.right.offset(-5);
            make.height.offset(200);
        }];
        
        _playingButton = [[UIButton alloc] init];
        [_playingButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
        [_playingButton addTarget:self action:@selector(actionPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playingButton];
        [_playingButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imageView.mas_centerY);
            make.centerX.equalTo(_imageView.mas_centerX);
            make.width.height.offset(100);
        }];

        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"这是搜大大难分难舍饭票千分疲惫非完全访问ufipbfiwq方碧平不i耳边风这是搜大大难分难舍饭票千分疲惫非完全访问ufipbfiwq方碧平不i耳边风";
        _contentLabel.backgroundColor = RGBColor(30, 30, 30);
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom).offset(5);
            make.left.offset(10);
            make.right.offset(-10);
        }];
        
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = RGBColor(30, 30, 30);
        [button addTarget:self action:@selector(actionSupport:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(5);
            make.left.offset(10);
            make.height.offset(20);
            make.width.offset(80);
        }];
        
        _supportButton = [[UIButton alloc] init];
        _supportButton.backgroundColor = RGBColor(30, 30, 30);
        [_supportButton setImage:[UIImage imageNamed:@"support_normal.png"] forState:UIControlStateNormal];
        [_supportButton setImage:[UIImage imageNamed:@"support_selected.png"] forState:UIControlStateSelected];
        [button addSubview:_supportButton];
        [_supportButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(5);
            make.width.offset(20);
        }];

        _supportLabel = [[UILabel alloc] init];
        _supportLabel.text = @"324";
        _supportLabel.textColor = [UIColor whiteColor];
        _supportLabel.font = [UIFont systemFontOfSize:13];
        [button addSubview:_supportLabel];
        [_supportLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.equalTo(_supportButton.mas_right).offset(10);
            make.width.offset(80);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2014-01-21 09:20";
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
            make.right.offset(-10);
            make.height.offset(20);
        }];
    }
    
    return self;
}

- (void)actionPlaying:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(trendsTableViewCellDidSelectPlaying:)]) {
        [_delegate trendsTableViewCellDidSelectPlaying:self];
    }
}

- (void)actionSupport:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(trendsTableViewCellDidSelectSupportButton:)]) {
        [_delegate trendsTableViewCellDidSelectSupportButton:self];
    }
}

- (void)setTrends:(YWTrendsModel *)trends {
    _trends = trends;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:trends.trendsMovie.movieCoverImage] placeholderImage:kPlaceholderMoiveImage];
    _supportButton.selected = trends.trendsIsSupport.integerValue;
    _contentLabel.text = trends.trendsContent;
    _supportLabel.text = trends.trendsSuppotNumbers;
    _timeLabel.text = trends.trendsPubdate;
}

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends {
    CGFloat height = 200+20;
    NSString *str = @"这是搜大大难分难舍饭票千分疲惫非完全访问ufipbfiwq方碧平不i耳边风这是搜大大难分难舍饭票千分疲惫非完全访问ufipbfiwq方碧平不i耳边风";
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    height += rect.size.height;
    height += 20;
    
    return height;
}


@end
