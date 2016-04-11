//
//  YWExperirnceViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWExperienceViewController.h"
#import "YWExperienceTableViewCell.h"
#import "YWExperienceDetailViewController.h"

@interface YWExperienceViewController()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation YWExperienceViewController
{
    UITableView         *_tableView;
    NSArray             *_titles;
    NSArray             *_infos;
    UILabel             *_experienceLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _titles = @[@"登录", @"发视频", @"完善资料"];
    _infos = @[@"+10分", @"+20分", @"+50分"];
    [self createRightItemWithTitle:@"说明"];
    
    [self createSubViews];
}

- (void)createSubViews {
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    head.backgroundColor = Subject_color;
    _experienceLabel = [[UILabel alloc] init];
    _experienceLabel.font = [UIFont systemFontOfSize:16];
    _experienceLabel.textAlignment = NSTextAlignmentCenter;
    _experienceLabel.textColor = RGBColor(230, 230, 230);
    NSString *str = [NSString stringWithFormat:@"%@分", _experience?:@"0"];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttributes:@{NSForegroundColorAttributeName: RGBColor(247, 153, 30), NSFontAttributeName: [UIFont boldSystemFontOfSize:30]} range:NSMakeRange(0, str.length-1)];
    _experienceLabel.attributedText = attr;
    [head addSubview:_experienceLabel];
    [_experienceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(100);
    }];
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"    经验值明细";
    label1.textColor = [UIColor whiteColor];
    [head addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(50);
        make.top.equalTo(_experienceLabel.mas_bottom);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    [_tableView registerClass:[YWExperienceTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.separatorColor = RGBColor(30, 30, 30);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = head;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    YWExperienceDetailViewController *vc = [[YWExperienceDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWExperienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.title = _titles[indexPath.row];
    cell.info = _infos[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
