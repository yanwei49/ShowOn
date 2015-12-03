//
//  YWCustomSegView.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWCustomSegView.h"

@implementation YWCustomSegView
{
    NSMutableArray   *_items;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setItemTitles:(NSArray *)itemTitles {
    _itemTitles = itemTitles;
    [_items removeAllObjects];
    for (NSInteger i=0; i<itemTitles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor whiteColor];
        button.selected = !i?YES:NO;
        [button addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:itemTitles[i] forState:UIControlStateNormal];
        [_items addObject:button];
        [self addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(kScreenWidth/itemTitles.count*i);
            make.top.bottom.offset(0);
            make.width.offset(kScreenWidth/itemTitles.count*i);
        }];
        if (i != itemTitles.count-1) {
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = SeparatorColor;
            [self addSubview:lineView];
            [lineView makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(button.mas_right);
                make.top.bottom.offset(0);
                make.width.offset(1);
            }];
        }
    }
 }

- (void)actionOnClick:(UIButton *)button {
    NSInteger index = [_items indexOfObject:button];

}

@end
