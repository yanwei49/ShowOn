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

#import "YWMouldModel.h"

@interface YWHotView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation YWHotView
{
    NSMutableArray      *_dataSource;
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
        _dataSource = [[NSMutableArray alloc] init];
        
        [self createSubViews];
        [self dataSource];

    }
    return self;
}

- (void)dataSource {
    for (NSInteger i=0; i<10; i++) {
        YWMouldModel *movie = [[YWMouldModel alloc] init];
        movie.mouldId = [NSString stringWithFormat:@"%ld", i];
        movie.mouldName = [NSString stringWithFormat:@"测试模板%ld", i+1];
        movie.mouldCoverImage = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        movie.mouldShootNums = @"120";
        movie.mouldTimeLength = @"1分20秒";
        
        [_dataSource addObject:movie];
    }
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
    cell.mould = _dataSource[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(hotViewDidSelectItemWithIndex:)]) {
        [_delegate hotViewDidSelectItemWithIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}


@end
