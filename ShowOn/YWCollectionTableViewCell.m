
//
//  YWCollectionTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWCollectionTableViewCell.h"
#import "YWMoviePlayView.h"
#import "YWFocusCommentTableViewCell.h"
#import "YWMovieModel.h"
#import "YWUserModel.h"
#import "YWTrendsModel.h"
#import "YWMovieTemplateModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YWCollectionTableViewCell
{
    UIImageView      *_avatorImageView;
    UILabel          *_userNameLabel;
    UILabel          *_timeLabel;
    UILabel          *_dateLabel;
    UILabel          *_contentLabel;
    UILabel          *_numsLabel;
    YWMoviePlayView  *_playMovieView;
    UIButton         *_playButton;
    UIButton         *_cooperateButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *selectView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        selectView.backgroundColor = RGBColor(70, 70, 70);
        self.selectedBackgroundView = selectView;
        self.contentView.backgroundColor = RGBColor(30, 30, 30);
        self.contentView.clipsToBounds = YES;
        
        UIView  *view = [[UIView alloc] init];
        view.backgroundColor = Subject_color;
        [self.contentView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.height.offset(60);
        }];
        
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.cornerRadius = 20;
        _avatorImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_avatorImageView];
        [_avatorImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.width.height.offset(40);
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = Subject_color;
        _userNameLabel.text = @"";
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_userNameLabel];
        [_userNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatorImageView.mas_top);
            make.left.equalTo(_avatorImageView.mas_right).offset(10);
            make.height.offset(20);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = Subject_color;
        _timeLabel.text = @"";
        _timeLabel.textColor = RGBColor(142, 142, 142);
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_avatorImageView.mas_bottom);
            make.left.equalTo(_avatorImageView.mas_right).offset(10);
            make.height.offset(15);
        }];
        
        _numsLabel = [[UILabel alloc] init];
        _numsLabel.backgroundColor = Subject_color;
        _numsLabel.text = @"";
        _numsLabel.textColor = RGBColor(142, 142, 142);
        _numsLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_numsLabel];
        [_numsLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_avatorImageView.mas_bottom);
            make.left.equalTo(_timeLabel.mas_right).offset(10);
            make.height.offset(15);
        }];
        
        _playButton = [[UIButton alloc] init];
        _playButton.backgroundColor = RGBColor(234, 234, 234);
        _playButton.layer.cornerRadius = 5;
        _playButton.layer.masksToBounds = YES;
        [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _playButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_playButton addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
        [_playButton setTitle:@"我来演" forState:UIControlStateNormal];
        [self.contentView addSubview:_playButton];
        [_playButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.height.offset(25);
            make.right.offset(-10);
            make.width.offset(60);
        }];
        
        _cooperateButton = [[UIButton alloc] init];
        _cooperateButton.backgroundColor = RGBColor(234, 234, 234);
        _cooperateButton.layer.cornerRadius = 5;
        _cooperateButton.layer.masksToBounds = YES;
        [_cooperateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cooperateButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cooperateButton addTarget:self action:@selector(actionCooperateButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cooperateButton setTitle:@"参与合演" forState:UIControlStateNormal];
        [self.contentView addSubview:_cooperateButton];
        [_cooperateButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.height.offset(25);
            make.right.equalTo(_playButton.mas_left).offset(-10);
            make.width.offset(60);
        }];
        
        _playMovieView = [[YWMoviePlayView alloc] init];
        _playMovieView.backgroundColor = RGBColor(30, 30, 30);
        _playMovieView.layer.masksToBounds = YES;
        _playMovieView.layer.cornerRadius = 5;
        [self.contentView addSubview:_playMovieView];
        [_playMovieView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(65);
            make.left.offset(5);
            make.right.offset(-5);
            make.height.offset(200);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"";
        _contentLabel.backgroundColor = RGBColor(30, 30, 30);
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_playMovieView.mas_bottom).offset(5);
            make.left.offset(10);
            make.right.offset(-10);
        }];
    }
    
    return self;
}

- (void)actionCooperateButton:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(collectionTableViewCellDidSelectCooperate:)]) {
        [_delegate collectionTableViewCellDidSelectCooperate:self];
    }
}

- (void)actionPlay:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(collectionTableViewCellDidSelectPlay:)]) {
        [_delegate collectionTableViewCellDidSelectPlay:self];
    }
}

- (void)setTrends:(YWTrendsModel *)trends {
    _trends = trends;
    [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:trends.trendsUser.portraitUri] placeholderImage:kPlaceholderUserAvatorImage];
    if (trends.trendsType.integerValue == 2) {
        //        NSMutableString *str = [NSMutableString string];
        //        [str appendString:movie.movieReleaseUser.userName];
        //        for (NSInteger i=0; i<movie.movieRecorderUsers.count; i++) {
        //            [str appendString:@"+"];
        //            [str appendString:[movie.movieRecorderUsers[i] userName]];
        //        }
        //        _userNameLabel.text = str;
    }else if (trends.trendsType.integerValue == 1) {
        _userNameLabel.text = trends.trendsUser.userName;
    }
    _timeLabel.text = trends.trendsMovie.movieTemplate.templateVideoTime;
    //    _timeLabel.text = [NSString stringWithFormat:@"%@分%@秒", [movie.movieTimeLength componentsSeparatedByString:@":"][0], [movie.movieTimeLength componentsSeparatedByString:@":"][1]];
    _contentLabel.text = trends.trendsContent;
    _numsLabel.text = [NSString stringWithFormat:@"播放%@次", trends.trendsMoviePlayCount];
    
}

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends {
    CGFloat height = 200+15+60;
    CGRect rect = [trends.trendsContent boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    height += rect.size.height;
    
    return height;
}



@end
