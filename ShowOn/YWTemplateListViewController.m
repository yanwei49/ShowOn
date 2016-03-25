//
//  YWTemplatListViewController.m
//  ShowOn
//
//  Created by David Yu on 14/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWTemplateListViewController.h"
#import "YWTemplateListTableViewCell.h"
#import "MJRefresh.h"
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWTranscribeViewController.h"
#import "YWMovieTemplateModel.h"

@interface YWTemplateListViewController ()<UITableViewDataSource, UITableViewDelegate, YWTemplateListTableViewCellDelegate>

@end

@implementation YWTemplateListViewController
{
    UITableView     *_tableView;
    NSMutableArray  *_dataSource;
    YWHttpManager   *_httpManager;
    NSInteger        _currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = _template.templateName;
    _dataSource = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _currentPage = 0;

    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestTemplateList];
}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestTemplateList];
    }];
}

#pragma mark - request
- (void)requestTemplateList {
    NSDictionary *parameters = @{@"templateSubTypeId": _template.templateSubTypeId, @"page": @(_currentPage)};
    [_httpManager requestTemplateSubCategoryList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_dataSource removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser templateWithArray:responseObject[@"templateList"]];
        [_dataSource addObjectsFromArray:array];
        [self noContentViewShowWithState:_dataSource.count?NO:YES];
        if (array.count<20) {
            _tableView.footer = nil;
        }else {
            _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestTemplateList];
            }];
        }
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWTemplateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YWTemplateListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.template = _dataSource[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
    vc.template = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - YWTemplateListTableViewCellDelegate
- (void)templateListTableViewCellDidSelectPlay:(YWTemplateListTableViewCell *)cell {
    YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
    vc.template = cell.template;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
