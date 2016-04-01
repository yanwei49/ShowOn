//
//  YWUserTableViewCell.m
//  ShowOn
//
//  Created by David Yu on 17/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWUserTableViewCell.h"
#import "YWUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YWUserTableViewCell
{
    UIImageView     *_avatorImageView;
    UILabel         *_nameLable;
    UIButton        *_stateButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(70, 70, 70);
        
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.backgroundColor = [UIColor whiteColor];
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.cornerRadius = 20;
        [self.contentView addSubview:_avatorImageView];
        [_avatorImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.width.height.offset(40);
        }];
        
        _stateButton = [[UIButton alloc] init];
        _stateButton.backgroundColor = RGBColor(70, 70, 70);
        [_stateButton setImage:[UIImage imageNamed:@"choose_normal.png"] forState:UIControlStateNormal];
        [_stateButton setImage:[UIImage imageNamed:@"choose_selected.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:_stateButton];
        [_stateButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.width.height.offset(20);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        _nameLable = [[UILabel alloc] init];
        _nameLable.backgroundColor = RGBColor(70, 70, 70);
        _nameLable.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLable];
        [_nameLable makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatorImageView.mas_right).offset(10);
            make.height.offset(20);
            make.right.equalTo(_stateButton.mas_left).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    
    return self;
}

- (void)setUser:(YWUserModel *)user {
    _user = user;
    [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:kPlaceholderUserAvatorImage];
    _nameLable.text = user.userName;
}

- (void)setState:(BOOL)state {
    _state = state;
    _stateButton.selected = state;
}

@end
