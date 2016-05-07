//
//  YWMovieCardMovieTableViewCell.h
//  ShowOn
//
//  Created by David Yu on 29/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWTrendsModel;
@class YWMovieCardMovieTableViewCell;
@protocol YWMovieCardMovieTableViewCellDelegate <NSObject>

- (void)movieCardMovieTableViewCellDidSelectPlay:(YWMovieCardMovieTableViewCell *)cell;

@end
@interface YWMovieCardMovieTableViewCell : UITableViewCell

@property (nonatomic, strong) YWTrendsModel *trends;
@property (nonatomic, assign) id<YWMovieCardMovieTableViewCellDelegate> delegate;

+ (CGFloat)cellHeightWithModel:(YWTrendsModel *)model;

@end
