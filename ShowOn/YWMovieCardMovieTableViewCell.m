//
//  YWMovieCardMovieTableViewCell.m
//  ShowOn
//
//  Created by David Yu on 29/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWMovieCardMovieTableViewCell.h"
#import "YWTrendsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWMovieModel.h"

@implementation YWMovieCardMovieTableViewCell
{
    UIImageView     *_imageView;
    UIButton        *_playingButton;
    UILabel         *_contentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(30, 30, 30);
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = RGBColor(30, 30, 30);
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(10);
            make.right.offset(-10);
        }];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(30, 30, 30);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(5);
            make.left.offset(5);
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
    }
    
    return self;
}

#pragma mark - action
- (void)actionPlaying:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieCardMovieTableViewCellDidSelectPlay:)]) {
        [_delegate movieCardMovieTableViewCellDidSelectPlay:self];
    }
}

#pragma mark - get set
- (void)setTrends:(YWTrendsModel *)trends {
    _trends = trends;
    _contentLabel.text = trends.trendsContent;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:trends.trendsMovie.movieCoverImage] placeholderImage:kPlaceholderMoiveImage];
}

+ (CGFloat)cellHeightWithModel:(YWTrendsModel *)model {
    CGFloat height = 210;
    CGRect rect = [model.trendsContent boundingRectWithSize:CGSizeMake(kScreenWidth-20, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    
    return height+rect.size.height;
}

@end
