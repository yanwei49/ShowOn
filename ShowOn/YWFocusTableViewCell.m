//
//  YWFocusTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWFocusTableViewCell.h"
#import "YWMoviePlayView.h"
#import "YWFocusCommentTableViewCell.h"
#import "YWMovieModel.h"
#import "YWUserModel.h"
#import "YWTrendsModel.h"
#import "YWMovieTemplateModel.h"
#import "YWSubsectionVideoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YWFocusTableViewCell()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation YWFocusTableViewCell
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
    UITableView      *_tableView;
    UIImageView      *_imageView;
    UIButton         *_playingButton;
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
        
        _playMovieView = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(0, 65, kScreenWidth, 200) playUrl:@""];
        _playMovieView.backgroundColor = Subject_color;
        _playMovieView.layer.masksToBounds = YES;
        _playMovieView.layer.cornerRadius = 5;
        [self.contentView addSubview:_playMovieView];
//        [_playMovieView makeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(65);
//            make.left.offset(5);
//            make.right.offset(-5);
//            make.height.offset(200);
//        }];
        
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(30, 30, 30);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [view addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(65);
            make.left.offset(5);
            make.right.offset(-5);
            make.height.offset(200);
        }];
        
        _playingButton = [[UIButton alloc] init];
        [_playingButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
        _playingButton.userInteractionEnabled = NO;
        [_playingButton addTarget:self action:@selector(actionPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_playingButton];
        [_playingButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imageView.mas_centerY);
            make.centerX.equalTo(_imageView.mas_centerX);
            make.width.equalTo(_imageView.mas_width);
            make.height.equalTo(_imageView.mas_height);
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

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBColor(30, 30, 30);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.userInteractionEnabled = NO;
        [_tableView registerClass:[YWFocusCommentTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.contentView addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        }];
    }
    
    return self;
}

- (void)actionPlaying:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(focusTableViewCellDidSelectPlaying:)]) {
        [_delegate focusTableViewCellDidSelectPlaying:self];
    }
}

- (void)actionCooperateButton:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(focusTableViewCellDidSelectCooperate:)]) {
        [_delegate focusTableViewCellDidSelectCooperate:self];
    }
}

- (void)actionPlay:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(focusTableViewCellDidSelectPlay:)]) {
        [_delegate focusTableViewCellDidSelectPlay:self];
    }
}

- (void)setTrends:(YWTrendsModel *)trends {
    _trends = trends;
//    _imageView.hidden = YES;
//    _playingButton.hidden = YES;
    _playMovieView.hidden = YES;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:trends.trendsMovie.movieCoverImage] placeholderImage:kPlaceholderMoiveImage];
//    _playMovieView.urlStr = trends.trendsMovie.movieUrl?:[_trends.trendsMovie.movieTemplate.templateSubsectionVideos[0] subsectionVideoUrl];
    _cooperateButton.hidden = (trends.trendsType.integerValue != 2)?YES:NO;
    [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:trends.trendsUser.portraitUri] placeholderImage:kPlaceholderMoiveImage];
    if (trends.trendsType.integerValue == 2) {
        NSMutableString *str = [NSMutableString string];
        [str appendString:trends.trendsUser.userName];
        for (NSInteger i=0; i<trends.trendsOtherPlayUsers.count; i++) {
            [str appendString:@"+"];
            [str appendString:[trends.trendsOtherPlayUsers[i] userName]];
        }
        _userNameLabel.text = str;
    }else if (trends.trendsType.integerValue == 1) {
        _userNameLabel.text = trends.trendsUser.userName;
    }
    _timeLabel.text = trends.trendsMovie.movieTemplate.templateVideoTime;
    _timeLabel.text = [NSString stringWithFormat:@"%@分%@秒", [trends.trendsMovie.movieTemplate.templateVideoTime componentsSeparatedByString:@":"][0], [trends.trendsMovie.movieTemplate.templateVideoTime componentsSeparatedByString:@":"][1]];
    _contentLabel.text = trends.trendsContent;
    _numsLabel.text = [NSString stringWithFormat:@"播放%@次", trends.trendsMoviePlayCount];
}

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends type:(TrendsCellType)type {
    CGFloat height = 200+15+60;
    CGRect rect = [trends.trendsContent boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    height += rect.size.height;
    if (type == kTrendsListType && trends.trendsComments.count) {
        height += [YWFocusCommentTableViewCell cellHeightWithComment:trends.trendsComments[0]];
    }
    
    return height;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _trends.trendsComments.count?1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWFocusCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.comment = _trends.trendsComments[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YWFocusCommentTableViewCell cellHeightWithComment:_trends.trendsComments[indexPath.row]];
}



@end
