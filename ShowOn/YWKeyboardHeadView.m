//
//  YWKeyboardHeadView.m
//  ShowOn
//
//  Created by David Yu on 16/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWKeyboardHeadView.h"

@implementation YWKeyboardHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
     
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:@"@_normal.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionAiteOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.width.height.offset(30);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    
    return self;
}

- (void)actionAiteOnClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(keyboardHeadViewButtonOnClick)]) {
        [_delegate keyboardHeadViewButtonOnClick];
    }
}

@end
