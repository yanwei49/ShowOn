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

@interface YWMovieCardTableViewCell()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation YWMovieCardTableViewCell
{
    UITableView     *_tableView;
    NSMutableArray  *_titles;
    NSMutableArray  *_contents;
    UIImageView     *_imageView;
    UIButton        *_playingButton;
    UILabel         *_contentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(30, 30, 30);
        _titles = [[NSMutableArray alloc] init];
        _contents = [[NSMutableArray alloc] init];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = RGBColor(30, 30, 30);
        _tableView.separatorColor = RGBColor(70, 70, 70);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.contentView addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
        }];
   
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"";
        _contentLabel.backgroundColor = RGBColor(30, 30, 30);
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableView.mas_bottom).offset(5);
            make.left.offset(10);
            make.right.offset(-10);
        }];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(30, 30, 30);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(5);
            make.left.offset(5);
            make.right.offset(-5);
            make.height.offset(200);
        }];
        
        _playingButton = [[UIButton alloc] init];
        [_playingButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
        [_playingButton addTarget:self action:@selector(actionPlaying:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_playingButton];
        [_playingButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imageView.mas_centerY);
            make.centerX.equalTo(_imageView.mas_centerX);
            make.width.height.offset(100);
        }];
    }
    
    return self;
}

#pragma mark - action
- (void)actionPlaying:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieCardTableViewCellDidSelectPlayingButton:)]) {
        [_delegate movieCardTableViewCellDidSelectPlayingButton:self];
    }
}

- (void)setModel:(YWMovieCardModel *)model {
    _model = model;
    [_titles removeAllObjects];
    [_contents removeAllObjects];
    NSArray *titles = @[@"认证", @"年龄", @"地区", @"星座", @"身高", @"三围", @"通告", @"邮箱"];
    NSArray *array = @[model.authentication?:@"", model.age?:@"", model.address?:@"", model.constellation?:@"", model.height?:@"", model.bwh?:@"", model.announce?:@"", model.email?:@""];
    for (NSInteger i=0; i<array.count; i++) {
        if ([array[i] length]) {
            [_titles addObject:titles[i]];
            [_contents addObject:array[i]];
        }
    }
    [_tableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30*_titles.count);
    }];
    [_tableView reloadData];
    _contentLabel.text = model.info;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.trends.trendsMovie.movieCoverImage] placeholderImage:kPlaceholderMoiveImage];
}

+ (CGFloat)cellHeightWithModel:(YWMovieCardModel *)model {
    NSInteger cnt = 0;
    NSArray *array = @[model.authentication?:@"", model.age?:@"", model.address?:@"", model.constellation?:@"", model.height?:@"", model.bwh?:@"", model.announce?:@"", model.email?:@""];
    for (NSInteger i=0; i<array.count; i++) {
        if ([array[i] length]) {
            cnt += 1;
        }
    }
    CGFloat height = 30*cnt;
    CGRect rect = [model.trends.trendsContent boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    
    return height+200+rect.size.height+10;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

@end
