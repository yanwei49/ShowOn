//
//  YWTemplatListViewController.m
//  ShowOn
//
//  Created by David Yu on 14/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWTemplateListViewController.h"
#import "YWTemplateListTableViewCell.h"
#import "YWMouldTypeModel.h"

#import "YWMouldModel.h"

@interface YWTemplateListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation YWTemplateListViewController
{
    UITableView     *_tableView;
    NSMutableArray  *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = _mouldType.mouldTypeName;
    _dataSource = [[NSMutableArray alloc] init];
    
    [self createSubViews];
    [self dataSource];
}

- (void)dataSource {
    for (NSInteger i=0; i<10; i++) {
        YWMouldModel *mould = [[YWMouldModel alloc] init];
        mould.mouldId = @"1";
        mould.mouldName = [NSString stringWithFormat:@"模板%ld", (long)i];
        mould.mouldCoverImage = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        
        [_dataSource addObject:mould];
    }
    [_tableView reloadData];
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
    cell.mould = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}


@end
