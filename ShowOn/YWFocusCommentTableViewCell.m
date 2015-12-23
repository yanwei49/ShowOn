
//
//  YWFocusCommentTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/16.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWFocusCommentTableViewCell.h"

@implementation YWFocusCommentTableViewCell
{
    UIImageView    *_avatorImageView;
    UILabel        *_userNameLabel;
    UILabel        *_timeLabel;
    UILabel        *_contentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = RGBColor(60, 60, 60);
        _timeLabel.text = @"2015-10-02";
        _timeLabel.textColor = RGBColor(142, 142, 142);
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatorImageView.mas_top);
            make.width.offset(100);
            make.height.offset(20);
            make.right.offset(-10);
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.backgroundColor = RGBColor(60, 60, 60);
        _userNameLabel.text = @"用户名";
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_userNameLabel];
        [_userNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatorImageView.mas_top);
            make.left.equalTo(_avatorImageView.mas_right).offset(10);
            make.height.offset(20);
            make.right.equalTo(_timeLabel.mas_left).offset(-10);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = RGBColor(60, 60, 60);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = RGBColor(142, 142, 142);
        _contentLabel.text = @"转发：这是w我接任务诶认为胖女人骗我呢唯品搜大大难分难舍饭票千分方碧平不i耳边风";
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userNameLabel.mas_bottom);
            make.left.equalTo(_userNameLabel.mas_left);
            make.right.offset(-10);
        }];
    }
    
    return self;
}


+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends {
    CGFloat height = 60;
    NSString *str = @"转发：这是w我接任务诶认为胖女人骗我呢唯品搜大大难分难舍饭票千分方碧平不i耳边风";
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    height += rect.size.height-20;
    
    return height;
}


@end
