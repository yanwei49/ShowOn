//
//  YWNoCotentView.m
//  ShowOn
//
//  Created by David Yu on 11/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWNoCotentView.h"

@implementation YWNoCotentView
{
    UILabel     *_contentLabel;
}

static YWNoCotentView *view;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[YWNoCotentView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    });
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"暂无内容";
        _contentLabel.textColor = RGBColor(160, 160, 169);
        [self addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.centerY.equalTo(self.mas_centerY);
            make.centerX.equalTo(self.mas_centerX);
        }];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

+ (void)showNoCotentViewWithState:(BOOL)state {
    [YWNoCotentView shareInstance];
    if (state) {
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    }else {
        [view removeFromSuperview];
    }
}

@end
