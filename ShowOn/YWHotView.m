//
//  YWHotView.m
//  ShowOn
//
//  Created by David Yu on 12/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWHotView.h"
#import "YWHotTableViewCell.h"
#import "YWSearchCollectionReusableView.h"
#import "YWUserDataViewController.h"
#import "YWHttpManager.h"
#import "YWParser.h"

@interface YWHotView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation YWHotView
{
    UITableView         *_tableView;
    UISearchBar         *_searchBar;
}

+ (YWHotView *)shareInstance {
    static YWHotView *hotVC;
    if (!hotVC) {
        hotVC = [[YWHotView alloc] init];
    }
    
    return hotVC;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
        
        [self createSubViews];

    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [_tableView reloadData];
}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YWHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIView *view = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        view.backgroundColor = Subject_color;
        cell.selectedBackgroundView = view;
    }
    cell.template = _dataSource[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(hotViewDidSelectItemWithTemplate:)]) {
        [_delegate hotViewDidSelectItemWithTemplate:_dataSource[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}


@end
