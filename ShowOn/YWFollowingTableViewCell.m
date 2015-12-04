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
        self.backgroundColor = [UIColor whiteColor];
        
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.backgroundColor = [UIColor whiteColor];
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.cornerRadius = 30;
        [self.contentView addSubview:_avatorImageView];
        [_avatorImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.offset(60);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
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
        _friendTypeButton.layer.borderWidth = 1;
        _friendTypeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:_friendTypeButton];
        [_friendTypeButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.offset(-20);
            make.width.offset(80);
            make.height.offset(40);
        }];
    }
    
    return self;
}

- (void)setUser:(YWUserModel *)user {
    _user = user;
    [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:user.userAvator] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = user.userName;
    [self changeFriendRelationType];
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
        default:
            break;
    }
}

- (void)actionOnClick:(UIButton *)buttom {
    if ([_gelegate respondsToSelector:@selector(followingTableViewCellDidSelectButton:)]) {
        [_gelegate followingTableViewCellDidSelectButton:self];
    }
}


@end
