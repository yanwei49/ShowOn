//
//  YWTrendsCategoryView.m
//  ShowOn
//
//  Created by David Yu on 16/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWTrendsCategoryView.h"

@interface YWTrendsCategoryView() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation YWTrendsCategoryView
{
    UITableView   *_tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBColor(240, 240, 240);
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = Subject_color;
        _tableView.scrollEnabled = NO;
        _tableView.separatorColor = RGBColor(230, 230, 230);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
    }
    
    return self;
}

- (void)setCategoryArray:(NSArray *)categoryArray {
    _categoryArray = categoryArray;
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = RGBColor(235, 235, 235);
    cell.textLabel.text = _categoryArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(trendsCategoryView:didSelectCategoryWithIndex:)]) {
        [_delegate trendsCategoryView:self didSelectCategoryWithIndex:indexPath.row];
    }
}

@end
