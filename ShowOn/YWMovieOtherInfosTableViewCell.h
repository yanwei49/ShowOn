//
//  YWMovieOtherInfosTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/27.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWTrendsModel;
@class YWUserModel;
@class YWMovieOtherInfosTableViewCell;
@protocol YWMovieOtherInfosTableViewCellDelegate <NSObject>

- (void)movieOtherInfosTableViewCellDidSelectSupport:(YWMovieOtherInfosTableViewCell *)cell;
- (void)movieOtherInfosTableViewCellDidSelectMore:(YWMovieOtherInfosTableViewCell *)cell;
- (void)movieOtherInfosTableViewCellDidSelectCollect:(YWMovieOtherInfosTableViewCell *)cell;
- (void)movieOtherInfosTableViewCellDidSelectShare:(YWMovieOtherInfosTableViewCell *)cell;
- (void)movieOtherInfosTableViewCell:(YWMovieOtherInfosTableViewCell *)cell didSelectUserAvator:(YWUserModel *)user;

@end
@interface YWMovieOtherInfosTableViewCell : UITableViewCell

@property (nonatomic, strong) YWTrendsModel *trends;
@property (nonatomic, assign) id<YWMovieOtherInfosTableViewCellDelegate> delegate;

@end
