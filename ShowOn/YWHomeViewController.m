//
//  YWHomeViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHomeViewController.h"
#import "YWCustomSegView.h"
#import "YWHotViewController.h"
#import "YWTemplateViewController.h"
#import "YWFocusViewController.h"

@interface YWHomeViewController ()<YWCustomSegViewDelegate>

@end

@implementation YWHomeViewController
{
    YWCustomSegView             *_itemView;
    YWHotViewController         *_hotVC;
    YWTemplateViewController    *_templateVC;
    YWFocusViewController       *_focusVC;
    NSInteger                    _showViewIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    _showViewIndex = 0;
    
    [self createSubViews];
}

- (void)createSubViews {
    NSArray *titles = @[@"热门", @"模板", @"关注"];
    _itemView = [[YWCustomSegView alloc] initWithItemTitles:titles];
    _itemView.delegate = self;
    [self.view addSubview:_itemView];
    [_itemView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(44);
    }];
    
    _focusVC = [[YWFocusViewController alloc] init];
    [self.view addSubview:_focusVC.view];
    [_focusVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-49);
    }];
    
    _templateVC = [[YWTemplateViewController alloc] init];
    [self.view addSubview:_templateVC.view];
    [_templateVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-49);
    }];
    
    _hotVC = [[YWHotViewController alloc] init];
    [self.view addSubview:_hotVC.view];
    [_hotVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_itemView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(-49);
    }];
}

- (void)changeShowView {
    switch (_showViewIndex) {
        case 0:
            [self .view bringSubviewToFront:_hotVC.view];
            break;
        case 1:
            [self .view bringSubviewToFront:_templateVC.view];
            break;
        case 2:
            [self .view bringSubviewToFront:_focusVC.view];
            break;
        default:
            break;
    }
}

#pragma mark - YWCustomSegViewDelegate
- (void)customSegView:(YWCustomSegView *)view didSelectItemWithIndex:(NSInteger)index {
    _showViewIndex = index;
    [self changeShowView];
}

@end
