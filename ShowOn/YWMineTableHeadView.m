//
//  YWMineTableHeadView.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWMineTableHeadView.h"
#import "YWUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YWMineTableHeadView
{
    UIImageView     *_avatorImageView;
    UILabel         *_nameLabel;
    UILabel         *_empiricalLabel;
    UILabel         *_authenticationLabel;
    UILabel         *_infosLabel;
    NSMutableArray  *_buttonArrays;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _buttonArrays = [[NSMutableArray alloc] init];
        
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.backgroundColor = [UIColor greenColor];
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.layer.cornerRadius = 30;
        [self addSubview:_avatorImageView];
        [_avatorImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.offset(10);
            make.width.height.offset(60);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_avatorImageView.mas_bottom).offset(10);
            make.height.offset(20);
        }];

        _empiricalLabel = [[UILabel alloc] init];
        _empiricalLabel.backgroundColor = [UIColor whiteColor];
        _empiricalLabel.font = [UIFont systemFontOfSize:12];
        _empiricalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_empiricalLabel];
        [_empiricalLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_centerX);
            make.height.offset(20);
            make.left.offset(0);
            make.top.equalTo(_nameLabel.mas_bottom);
        }];
        
        _authenticationLabel = [[UILabel alloc] init];
        _authenticationLabel.backgroundColor = [UIColor whiteColor];
        _authenticationLabel.font = [UIFont systemFontOfSize:12];
        _authenticationLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_authenticationLabel];
        [_authenticationLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX);
            make.height.offset(20);
            make.right.offset(0);
            make.top.equalTo(_empiricalLabel.mas_top);
        }];

        _infosLabel = [[UILabel alloc] init];
        _infosLabel.backgroundColor = [UIColor whiteColor];
        _infosLabel.font = [UIFont systemFontOfSize:12];
        _infosLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_infosLabel];
        [_infosLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_empiricalLabel.mas_bottom);
            make.left.offset(40);
            make.height.offset(20);
            make.right.offset(-20);
        }];
        
        NSArray *titles = @[@"动态", @"关注", @"粉丝", @"收藏"];
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton *button = [[UIButton alloc ] init];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:button];
            [_buttonArrays addObject:button];
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(((kScreenWidth-100)/4+20)*i+20);
                make.top.equalTo(_infosLabel.mas_bottom);
                make.height.offset(30);
                make.width.offset((kScreenWidth-100)/4);
            }];
        }
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(1);
        }];
    }
    
    return self;
}

#pragma mark - action
- (void)actionOnClick:(UIButton *)button {
    NSInteger index = [_buttonArrays indexOfObject:button];
    if ([_delegate respondsToSelector:@selector(mineTableHeadView:didSelectButtonWithIndex:)]) {
        [_delegate mineTableHeadView:self didSelectButtonWithIndex:index];
    }
}

- (void)actionSelectAvator {
    if ([_delegate respondsToSelector:@selector(mineTableHeadViewDidSelectAvator)]) {
        [_delegate mineTableHeadViewDidSelectAvator];
    }
}

- (void)setUser:(YWUserModel *)user {
    _user = user;
    [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:user.userAvator] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = [NSString stringWithFormat:@"%@       %@", user.userName, user.userRank];
    _empiricalLabel.text = [NSString stringWithFormat:@"经验值 %@", user.userEmpirical];
    _authenticationLabel.text = user.userAuthentication;
    _infosLabel.text = user.userInfos;
    NSArray *titles = @[@"动态", @"关注", @"粉丝", @"收藏"];
    UIButton *button1 = _buttonArrays[0];
    UIButton *button2 = _buttonArrays[0];
    UIButton *button3 = _buttonArrays[0];
    UIButton *button4 = _buttonArrays[0];
    [button1 setTitle:[NSString stringWithFormat:@"%@%@", titles[0], user.userTrendsNums] forState:UIControlStateNormal];
    [button2 setTitle:[NSString stringWithFormat:@"%@%@", titles[1], user.userFocusNums] forState:UIControlStateNormal];
    [button3 setTitle:[NSString stringWithFormat:@"%@%@", titles[2], user.userFollowsNums] forState:UIControlStateNormal];
    [button4 setTitle:[NSString stringWithFormat:@"%@%@", titles[3], user.userCollectNums] forState:UIControlStateNormal];
}

@end
