//
//  YWMovieCommentTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/27.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWMovieCommentTableViewCell.h"
#import "YWCommentModel.h"
#import "YWUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YWMovieCommentTableViewCell
{
    UIImageView    *_avatorImageView;
    UILabel        *_userNameLabel;
    UILabel        *_timeLabel;
    UILabel        *_contentLabel;
    UIButton       *_supportButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *selectView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        selectView.backgroundColor = RGBColor(70, 70, 70);
        self.selectedBackgroundView = selectView;
        self.contentView.backgroundColor = RGBColor(60, 60, 60);
        
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.cornerRadius = 20;
        _avatorImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_avatorImageView];
        [_avatorImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.width.height.offset(40);
        }];
        
        _supportButton = [[UIButton alloc] init];
        _supportButton.backgroundColor = RGBColor(60, 60, 60);
        [_supportButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_supportButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_supportButton addTarget:self action:@selector(actionOnClickSupport:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_supportButton];
        [_supportButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.offset(-10);
            make.height.width.offset(20);
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = RGBColor(60, 60, 60);
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
        _timeLabel.backgroundColor = RGBColor(60, 60, 60);
        _timeLabel.text = @"";
        _timeLabel.textColor = RGBColor(142, 142, 142);
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatorImageView.mas_top);
            make.right.equalTo(_supportButton.mas_left).offset(-10);
            make.height.offset(20);
            make.left.equalTo(_userNameLabel.mas_right).offset(10);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGBColor(30, 30, 30);
        [self.contentView addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userNameLabel.mas_left);
            make.height.offset(0.5);
            make.bottom.right.offset(0);
        }];

        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = RGBColor(60, 60, 60);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = RGBColor(142, 142, 142);
        _contentLabel.text = @"";
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userNameLabel.mas_bottom);
            make.left.equalTo(_userNameLabel.mas_left);
            make.right.offset(-10);
            make.bottom.equalTo(line.mas_top);
        }];
    }
    
    return self;
}

- (void)actionOnClickSupport:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieCommentTableViewCellDidSelectSupport:)]) {
        [_delegate movieCommentTableViewCellDidSelectSupport:self];
    }
}

- (void)setComment:(YWCommentModel *)comment {
    _comment = comment;
    [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:comment.commentUser.portraitUri] placeholderImage:kPlaceholderUserAvatorImage];
    _userNameLabel.text = comment.commentUser.userName;
    _timeLabel.text = comment.commentTime;
    _contentLabel.text = comment.commentContent;
}

+(CGFloat)cellHeightWithComment:(YWCommentModel *)comment {
    CGFloat height = 60;
    CGRect rect = [comment.commentContent boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    if (rect.size.height>20) {
        height += rect.size.height-20;
    }
    
    return height;
}



@end
