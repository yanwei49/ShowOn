//
//  YWMovieCardTableViewCell.m
//  ShowOn
//
//  Created by David Yu on 11/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWMovieCardTableViewCell.h"
#import "YWMovieCardModel.h"
#import "YWTrendsModel.h"
#import "YWMovieModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWMovieCardMovieTableViewCell.h"

@interface YWMovieCardTableViewCell()<UITableViewDataSource, UITableViewDelegate, YWMovieCardMovieTableViewCellDelegate>

@end

@implementation YWMovieCardTableViewCell
{
    UITableView     *_tableView;
    NSMutableArray  *_titles;
    NSMutableArray  *_contents;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(30, 30, 30);
        _titles = [[NSMutableArray alloc] init];
        _contents = [[NSMutableArray alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[YWMovieCardMovieTableViewCell class] forCellReuseIdentifier:@"movieCell"];
        _tableView.backgroundColor = RGBColor(30, 30, 30);
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.contentView addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
    }
    
    return self;
}

#pragma mark - get set
- (void)setModel:(YWMovieCardModel *)model {
    _model = model;
    [_titles removeAllObjects];
    [_contents removeAllObjects];
    NSArray *titles = @[@"姓名", @"年龄", @"地区", @"星座", @"身高", @"三围", @"通告", @"邮箱"];
    NSArray *array = @[model.authentication?:@"", model.age?:@"", model.address?:@"", model.constellation?:@"", model.height?:@"", model.bwh?:@"", model.announce?:@"", model.email?:@""];
    for (NSInteger i=0; i<array.count; i++) {
        if ([array[i] length]) {
            [_titles addObject:titles[i]];
            [_contents addObject:array[i]];
        }
    }
    [_tableView reloadData];
}

+ (CGFloat)cellHeightWithModel:(YWMovieCardModel *)model withIndex:(NSInteger)index {
    NSInteger cnt = 0;
    NSArray *array = @[model.authentication?:@"", model.age?:@"", model.address?:@"", model.constellation?:@"", model.height?:@"", model.bwh?:@"", model.announce?:@"", model.email?:@""];
    for (NSInteger i=0; i<array.count; i++) {
        if ([array[i] length]) {
            cnt += 1;
        }
    }
    CGFloat height = 0;
    if (!index) {
        height += 40*cnt;
    }
    for (YWTrendsModel *trend in model.trends) {
        height += 210;
        CGRect rect = [trend.trendsContent boundingRectWithSize:CGSizeMake(kScreenWidth-20, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
        
        height += rect.size.height;
    }

    return height;
}

#pragma mark - YWMovieCardMovieTableViewCellDelegate
- (void)movieCardMovieTableViewCellDidSelectPlay:(YWMovieCardMovieTableViewCell *)cell {
    if ([_delegate respondsToSelector:@selector(movieCardTableViewCellDidSelectPlayingButton:)]) {
        [_delegate movieCardTableViewCellDidSelectPlayingButton:cell.trends];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_index) {
        return _model.trends.count;
    }
    return _titles.count+_model.trends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_index) {
        if (indexPath.row < _titles.count) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.backgroundColor = RGBColor(50, 50, 50);
            cell.textLabel.text = _titles[indexPath.row];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentRight;
            label.backgroundColor = RGBColor(50, 50, 50);
            label.textColor = [UIColor whiteColor];
            label.text = _contents[indexPath.row];
            cell.accessoryView = label;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 39.5, kScreenWidth-20, 0.5)];
            line.backgroundColor = RGBColor(30, 30, 30);
            [cell.contentView addSubview:line];
            
            return cell;
        }else {
            YWMovieCardMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
            cell.trends = _model.trends[indexPath.row-_titles.count];
            cell.delegate = self;
            
            return cell;
        }
    }else {
        YWMovieCardMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
        cell.trends = _model.trends[indexPath.row];
        cell.delegate = self;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_index) {
        return [YWMovieCardMovieTableViewCell cellHeightWithModel:_model.trends[indexPath.row]];
    }
    return (indexPath.row < _titles.count)?40:[YWMovieCardMovieTableViewCell cellHeightWithModel:_model.trends[indexPath.row-_titles.count]];
}

@end
