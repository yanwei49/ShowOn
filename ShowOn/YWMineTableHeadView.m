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
    UIImageView     *_rankImageView;
    NSMutableArray  *_buttonArrays;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
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
        _nameLabel.text = @"用户名";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = Subject_color;
        [self addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_avatorImageView.mas_bottom).offset(10);
            make.height.offset(20);
        }];

        _rankImageView = [[UIImageView alloc] init];
        _rankImageView.backgroundColor = [UIColor greenColor];
        [self addSubview:_rankImageView];
        [_rankImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.left.equalTo(_nameLabel.mas_right).offset(20);
            make.width.height.offset(20);
        }];

        _empiricalLabel = [[UILabel alloc] init];
        _empiricalLabel.backgroundColor = Subject_color;
        _empiricalLabel.textColor = [UIColor whiteColor];
        _empiricalLabel.textAlignment = NSTextAlignmentRight;
        _empiricalLabel.text = @"经验值 9210";
        _empiricalLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_empiricalLabel];
        [_empiricalLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_centerX).offset(-20);
            make.height.offset(20);
            make.left.offset(20);
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        }];
        
        _authenticationLabel = [[UILabel alloc] init];
        _authenticationLabel.backgroundColor = Subject_color;
        _authenticationLabel.textColor = [UIColor whiteColor];
        _authenticationLabel.textAlignment = NSTextAlignmentLeft;
        _authenticationLabel.text = @"认证信息";
        _authenticationLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_authenticationLabel];
        [_authenticationLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX).offset(20);
            make.height.offset(20);
            make.right.offset(-20);
            make.top.equalTo(_empiricalLabel.mas_top);
        }];

        _infosLabel = [[UILabel alloc] init];
        _infosLabel.backgroundColor = Subject_color;
        _infosLabel.textColor = [UIColor whiteColor];
        _infosLabel.text = @"心情文字，新闻问你访问if为你疯狂我newfound你尽快";
        _infosLabel.font = [UIFont systemFontOfSize:14];
        _infosLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_infosLabel];
        [_infosLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-5);
            make.left.offset(40);
            make.height.offset(20);
            make.right.offset(-20);
        }];
        
        NSArray *titles = @[@"2001\n动态", @"111\n关注", @"213\n粉丝", @"42342\n收藏"];
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton *button = [[UIButton alloc ] init];
            button.backgroundColor = Subject_color;
            button.titleLabel.numberOfLines = 0;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:RGBColor(202, 202, 202) forState:UIControlStateNormal];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:button];
            [_buttonArrays addObject:button];
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(((kScreenWidth-100)/4+20)*i+20);
                make.top.equalTo(_empiricalLabel.mas_bottom).offset(5);
                make.bottom.equalTo(_infosLabel.mas_top).offset(-5);
                make.width.offset((kScreenWidth-100)/4);
            }];
        }
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
