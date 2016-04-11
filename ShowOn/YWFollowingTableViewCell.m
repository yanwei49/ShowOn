//
//  YWFollowingTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWFollowingTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWUserModel.h"

@implementation YWFollowingTableViewCell
{
    UIImageView    *_avatorImageView;
    UILabel        *_nameLabel;
    UIButton       *_friendTypeButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(50, 50, 50);
        
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.backgroundColor = RGBColor(50, 50, 50);
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.cornerRadius = 30;
        [self.contentView addSubview:_avatorImageView];
        [_avatorImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.offset(60);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = RGBColor(50, 50, 50);
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(_avatorImageView.mas_right).offset(10);
            make.height.offset(20);
        }];
        
        _friendTypeButton = [[UIButton alloc] init];
        _friendTypeButton.backgroundColor = [UIColor whiteColor];
        [_friendTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_friendTypeButton addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _friendTypeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _friendTypeButton.layer.masksToBounds = YES;
        _friendTypeButton.layer.cornerRadius = 5;
//        _friendTypeButton.layer.borderWidth = 1;
//        _friendTypeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:_friendTypeButton];
        [_friendTypeButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.offset(-20);
            make.width.offset(80);
            make.height.offset(30);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(0.5);
        }];
    }
    
    return self;
}

- (void)setUser:(YWUserModel *)user {
    _user = user;
    [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:kPlaceholderUserAvatorImage];
    _nameLabel.text = user.userName;
    [self changeFriendRelationType];
}

- (void)setRelationButtonState:(BOOL)relationButtonState {
    _relationButtonState = relationButtonState;
    _friendTypeButton.hidden = relationButtonState;
}

- (void)changeFriendRelationType {
    switch (_user.userRelationType) {
        case kBeFocus:
            [_friendTypeButton setTitle:@"+关注" forState:UIControlStateNormal];
            break;
        case kFocus:
            [_friendTypeButton setTitle:@"取消关注" forState:UIControlStateNormal];
            break;
        case kEachOtherFocus:
            [_friendTypeButton setTitle:@"相互关注" forState:UIControlStateNormal];
            break;
        case kBlackList:
            [_friendTypeButton setTitle:@"取消黑名单" forState:UIControlStateNormal];
            break;
        case kWeiboUser:
            [_friendTypeButton setTitle:@"邀请" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)actionOnClick:(UIButton *)buttom {
    if ([_delegate respondsToSelector:@selector(followingTableViewCellDidSelectButton:)]) {
        [_delegate followingTableViewCellDidSelectButton:self];
    }
}


@end
