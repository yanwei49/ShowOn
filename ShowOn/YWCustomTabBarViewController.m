//
//  YWCustomTabBarViewController.m
//  ShowOn
//
//  Created by David Yu on 7/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWCustomTabBarViewController.h"

@interface YWCustomTabBarViewController ()

@end

@implementation YWCustomTabBarViewController
{
    NSMutableArray   *_items;
    UIView           *_view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.tintColor = RGBColor(146, 146, 146);
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
//    self.tabBar.backgroundColor = RGBColor(30, 30, 30);
//    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.hidden = YES;
    _items = [[NSMutableArray alloc] init];
    
    _view = [[UIView alloc] init];
    _view.backgroundColor = RGBColor(30, 30, 30);
    [self.view addSubview:_view];
    [_view makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(49);
    }];
}

- (void)setItemNums:(NSInteger)itemNums {
    _itemNums = itemNums;
    for (NSInteger i=0; i<itemNums; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = RGBColor(30, 30, 30);
        [button addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_items addObject:button];
        [_view addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(kScreenWidth/itemNums*i);
            make.width.offset(kScreenWidth/itemNums);
        }];
    }
}

- (void)setImageNames:(NSArray *)imageNames {
    _imageNames = imageNames;
    for (NSInteger i=0; i<_itemNums; i++) {
        UIButton *button = _items[i];
        [button setImage:[UIImage imageNamed:_imageNames[i]] forState:UIControlStateNormal];
    }
}

- (void)setHiddenState:(BOOL)hiddenState {
    _hiddenState = hiddenState;
    _view.hidden = hiddenState;
}

- (void)actionOnClick:(UIButton *)button {
    NSInteger index = [_items indexOfObject:button];
    for (NSInteger i=0; i<_itemNums; i++) {
        UIButton *button1 = _items[i];
        button1.selected = (i==index)?YES:NO;
    }
    if ([_itemDelegate respondsToSelector:@selector(customTabBarViewControllerDidSelectWithIndex:)]) {
        [_itemDelegate customTabBarViewControllerDidSelectWithIndex:index];
    }
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    for (NSInteger i=0; i<_itemNums; i++) {
        UIButton *button = _items[i];
        [button setTitle:titles[i] forState:UIControlStateNormal];
    }
}

- (void)setItemSelectIndex:(NSInteger)itemSelectIndex {
    _itemSelectIndex = itemSelectIndex;
    for (NSInteger i=0; i<_items.count; i++) {
        UIButton *button = _items[i];
        button.selected = (itemSelectIndex==i)?YES:NO;
    }
}

@end
