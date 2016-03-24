//
//  YWCommentTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWCommentTableViewCell.h"
#import "YWCommentModel.h"
#import "YWUserModel.h"
#import "YWTrendsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YWCommentTableViewCell
{
    UIImageView    *_imageView;
    UIImageView    *_avatorImageView;
    UILabel        *_userNameLabel;
    UILabel        *_timeLabel;
    UILabel        *_contentLabel;
    UILabel        *_replyLabel;
    UIButton       *_playButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = Subject_color;
        
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.cornerRadius = 30;
        _avatorImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_avatorImageView];
        [_avatorImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.width.height.offset(60);
        }];
        
        UIView  *view = [[UIView alloc] init];
        view.backgroundColor = RGBColor(30, 30, 30);
        [self.contentView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(10);
        }];

        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = CornerRadius;
        _imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.right.offset(-10);
            make.width.height.offset(80);
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = Subject_color;
        _userNameLabel.text = @"用户名";
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
        _timeLabel.text = @"2015-10-02";
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_userNameLabel.mas_centerY);
            make.left.equalTo(_userNameLabel.mas_right).offset(10);
            make.height.offset(20);
            make.right.equalTo(_imageView.mas_left).offset(-10);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = Subject_color;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = RGBColor(142, 142, 142);
        _contentLabel.text = @"测试机哦死哦大受打击哦倒数第奥迪哈苏哈哈奥法";
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userNameLabel.mas_bottom).offset(5);
            make.left.equalTo(_userNameLabel.mas_left);
            make.right.equalTo(_imageView.mas_left).offset(-10);
        }];

        _replyLabel = [[UILabel alloc] init];
        _replyLabel.backgroundColor = Subject_color;
        _replyLabel.text = @"回复了我的评论：我的发我发我范围哦哦我日哦玩儿和沃尔";
        _replyLabel.textColor = RGBColor(102, 102, 102);
        _replyLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_replyLabel];
        [_replyLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(5);
            make.left.equalTo(_userNameLabel.mas_left);
            make.right.equalTo(_imageView.mas_left).offset(-10);
            make.height.offset(20);
        }];
        
        _playButton = [[UIButton alloc] init];
        _playButton.backgroundColor = Subject_color;
        [_playButton setImage:[UIImage imageNamed:@"play_list.png"] forState:UIControlStateNormal];
//        [_playButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playButton];
        [_playButton makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(30);
            make.centerY.equalTo(_imageView.mas_centerY);
            make.centerX.equalTo(_imageView.mas_centerX);
        }];
    }
    
    return self;
}

- (void)actionOnClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(commentTableViewCellDidSelectPlay:)]) {
        [_delegate commentTableViewCellDidSelectPlay:self];
    }
}

- (void)setComment:(YWCommentModel *)comment {
    _comment = comment;
    [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:comment.commentTrends.trendsUser.portraitUri] placeholderImage:kPlaceholderUserAvatorImage];
    _replyLabel.text = comment.commentContent;
    _timeLabel.text = comment.commentTime;
    _contentLabel.text = comment.beCommentContent;
    if (comment.commentType == 1) {
        NSMutableString *name = [NSMutableString stringWithString:comment.commentTrends.trendsUser.userName?:@""];
        for (YWUserModel *user in comment.commentTrends.trendsMovieCooperateUsers) {
            [name appendFormat:@"+"];
            [name appendFormat:@"%@", user.userName];
        }
        _userNameLabel.text = name;
    }else {
        _userNameLabel.text = comment.beCommentUser.userName;
    }

}

+ (CGFloat)cellHeightForMode:(YWCommentModel *)model {
    CGFloat height = 90;
    height += 20;
    
    return height;
}

@end
