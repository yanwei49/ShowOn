//
//  YWHotItemViewController.m
//  ShowOn
//
//  Created by 颜魏 on 16/1/12.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWHotItemViewController.h"
#import "YWMovieCommentTableViewCell.h"
#import "YWHotTableViewCell.h"

@interface YWHotItemViewController ()<UITableViewDataSource, UITableViewDelegate, YWMovieCommentTableViewCellDelegate>

@end

@implementation YWHotItemViewController
{
    UISegmentedControl  *_segmentedControl;
    UITableView         *_tableView;
    NSMutableArray      *_dataSource;
    NSMutableArray      *_trends;
    NSMutableArray      *_comments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.navigationController.navigationBarHidden = NO;
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"排行", @"评论"]];
    _segmentedControl.frame = CGRectMake(0, 0, 100, 35);
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(actionSegValueChange) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor redColor];
    self.navigationItem.titleView = _segmentedControl;
    _dataSource = [[NSMutableArray alloc] init];
    _trends = [[NSMutableArray alloc] init];
    _comments = [[NSMutableArray alloc] init];
    
    [self createSubViews];
}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWMovieCommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    [_tableView registerClass:[YWHotTableViewCell class] forCellReuseIdentifier:@"templateCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"trendsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - action
- (void)actionSegValueChange {
    [_dataSource removeAllObjects];
    if (!_segmentedControl.selectedSegmentIndex) {
        [_dataSource addObjectsFromArray:_trends];
    }else {
        [_dataSource addObjectsFromArray:_comments];
    }
    [_tableView reloadData];
}

#pragma nmark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_segmentedControl.selectedSegmentIndex) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_segmentedControl.selectedSegmentIndex) {
        return !section?1:_dataSource.count;
    }else {
        return _dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_segmentedControl.selectedSegmentIndex) {
        if (!indexPath.section) {
            YWHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"templateCell"];
            cell.template = _template;
            
            return cell;
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trendsCell"];
            
            return cell;
        }
    }else {
        YWMovieCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell.delegate = self;
        cell.comment = _dataSource[indexPath.row];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_segmentedControl.selectedSegmentIndex) {
        return 200;
    }else {
        return 80;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!_segmentedControl.selectedSegmentIndex && !section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        view.backgroundColor = Subject_color;
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = Subject_color;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"排行榜";
        [view addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(10);
        }];
        
        return view;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!_segmentedControl.selectedSegmentIndex && !section) {
        return 30;
    }else {
        return 0.00001;
    }
}


#pragma mark - YWMovieCommentTableViewCellDelegate
- (void)movieCommentTableViewCellDidSelectSupport:(YWMovieCommentTableViewCell *)cell {
    if (false) {
        
    }else {
        [self login];
    }
}


@end
