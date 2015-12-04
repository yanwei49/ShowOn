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
    NSArray          *_itemTitles;
}

- (instancetype)initWithItemTitles:(NSArray *)itemTitles {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        _items = [[NSMutableArray alloc] init];
        _itemTitles = itemTitles;
        _textFont = [UIFont systemFontOfSize:15];
        _textColor = [UIColor blackColor];
        _selectTextColor = [UIColor whiteColor];
        _backgroundColor = [UIColor whiteColor];
        _selectBackgroundColor = [UIColor orangeColor];
        _itemSelectIndex = 0;
     
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = SeparatorColor;
        [self addSubview:lineView];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.offset(0);
            make.height.offset(1);
        }];
            
        for (NSInteger i=0; i<itemTitles.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:itemTitles[i] forState:UIControlStateNormal];
            [_items addObject:button];
            [self addSubview:button];
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kScreenWidth/itemTitles.count*i);
                make.bottom.offset(-1);
                make.top.offset(1);
                make.width.offset(kScreenWidth/itemTitles.count);
            }];
            if (i != (itemTitles.count-1)) {
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = SeparatorColor;
                [button addSubview:lineView];
                [lineView makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(button.mas_right);
                    make.top.bottom.offset(0);
                    make.width.offset(1);
                }];
            }
        }
        [self setItemAttribute];
        
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = SeparatorColor;
        [self addSubview:lineView1];
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.offset(0);
            make.height.offset(1);
        }];
    }
    
    return self;
}

- (void)setItemSelectIndex:(NSInteger)itemSelectIndex {
    _itemSelectIndex = itemSelectIndex;
    [self setItemAttribute];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setItemAttribute];
}

- (void)setSelectBackgroundColor:(UIColor *)selectBackgroundColor {
    _selectBackgroundColor = selectBackgroundColor;
    [self setItemAttribute];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setItemAttribute];
}

- (void)setSelectTextColor:(UIColor *)selectTextColor {
    _selectTextColor = selectTextColor;
    [self setItemAttribute];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [self setItemAttribute];
}

- (void)setItemAttribute {
    for (NSInteger i=0; i<_items.count; i++) {
        UIButton *button = _items[i];
        button.backgroundColor = (i==_itemSelectIndex)?_selectBackgroundColor:_backgroundColor;
        [button setTitleColor:(i==_itemSelectIndex)?_selectTextColor:_textColor forState:UIControlStateNormal];
        button.titleLabel.font = _textFont;
    }
}

- (void)actionOnClick:(UIButton *)button {
    NSInteger index = [_items indexOfObject:button];
    _itemSelectIndex = index;
    [self setItemAttribute];
    if ([_delegate respondsToSelector:@selector(customSegView:didSelectItemWithIndex:)]) {
        [_delegate customSegView:self didSelectItemWithIndex:index];
    }
}



@end
