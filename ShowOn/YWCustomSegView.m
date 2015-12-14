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
    NSMutableArray   *_views;
    NSMutableArray   *_lineViews;
    NSArray          *_itemTitles;
}

- (instancetype)initWithItemTitles:(NSArray *)itemTitles {
    self = [super init];
    if (self) {
        self.backgroundColor = Subject_color;
        
        _items = [[NSMutableArray alloc] init];
        _views = [[NSMutableArray alloc] init];
        _lineViews = [[NSMutableArray alloc] init];
        _itemTitles = itemTitles;
        _ywTextFont = [UIFont systemFontOfSize:15];
        _ywTextColor = [UIColor whiteColor];
        _ywSelectTextColor = [UIColor greenColor];
        _ywBackgroundColor = Subject_color;
        _ywSelectBackgroundColor = Subject_color;
        _itemSelectIndex = 0;
     
//        UIView *lineView = [[UIView alloc] init];
//        lineView.backgroundColor = SeparatorColor;
//        [self addSubview:lineView];
//        [lineView makeConstraints:^(MASConstraintMaker *make) {
//            make.right.top.left.offset(0);
//            make.height.offset(1);
//        }];
        
        for (NSInteger i=0; i<itemTitles.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:itemTitles[i] forState:UIControlStateNormal];
            [_items addObject:button];
            [self addSubview:button];
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kScreenWidth/itemTitles.count*i);
                make.bottom.offset(0);
                make.top.offset(1);
                make.width.offset(kScreenWidth/itemTitles.count);
            }];
            if (i != (itemTitles.count-1)) {
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = SeparatorColor;
                lineView.hidden = YES;
                [button addSubview:lineView];
                [_lineViews addObject:lineView];
                [lineView makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(button.mas_right);
                    make.top.offset(10);
                    make.top.offset(-10);
                    make.width.offset(1);
                }];
            }
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = (!i)?_ywSelectTextColor:Subject_color;
            [self addSubview:view];
            [_views addObject:view];
            [view makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kScreenWidth/itemTitles.count*i);
                make.bottom.offset(0);
                make.width.offset(kScreenWidth/itemTitles.count);
                make.height.offset(3);
            }];
        }
        [self setItemAttribute];
//        
//        UIView *lineView1 = [[UIView alloc] init];
//        lineView1.backgroundColor = SeparatorColor;
//        [self addSubview:lineView1];
//        [lineView makeConstraints:^(MASConstraintMaker *make) {
//            make.right.bottom.left.offset(0);
//            make.height.offset(1);
//        }];
    }
    
    return self;
}

- (void)setItemSelectIndex:(NSInteger)itemSelectIndex {
    _itemSelectIndex = itemSelectIndex;
    [self setItemAttribute];
}

- (void)setYwSelectBackgroundColor:(UIColor *)ywSelectBackgroundColor {
    _ywSelectBackgroundColor = ywSelectBackgroundColor;
    [self setItemAttribute];
}

- (void)setYwBackgroundColor:(UIColor *)ywBackgroundColor {
    _ywBackgroundColor = ywBackgroundColor;
    [self setItemAttribute];
}

- (void)setYwTextColor:(UIColor *)ywTextColor {
    _ywTextColor = ywTextColor;
    [self setItemAttribute];
}

- (void)setYwSelectTextColor:(UIColor *)ywSelectTextColor {
    _ywSelectTextColor = ywSelectTextColor;
    [self setItemAttribute];
}

- (void)setTextFont:(UIFont *)textFont {
    textFont = textFont;
    [self setItemAttribute];
}

- (void)setHiddenLineView:(BOOL)hiddenLineView {
    for (UIView *view in _lineViews) {
        view.hidden = hiddenLineView;
    }
}

- (void)setItemAttribute {
    for (NSInteger i=0; i<_items.count; i++) {
        UIButton *button = _items[i];
        UIView *view = _views[i];
        view.backgroundColor = (i==_itemSelectIndex)?_ywSelectTextColor:Subject_color;
        button.backgroundColor = (i==_itemSelectIndex)?_ywSelectBackgroundColor:_ywBackgroundColor;
        [button setTitleColor:(i==_itemSelectIndex)?_ywSelectTextColor:_ywTextColor forState:UIControlStateNormal];
        button.titleLabel.font = _ywTextFont;
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
