//
//  YWMovieCardTableViewCell.h
//  ShowOn
//
//  Created by David Yu on 11/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieCardModel;
@class YWMovieCardTableViewCell;
@class YWTrendsModel;
@protocol YWMovieCardTableViewCellDelegate <NSObject>

- (void)movieCardTableViewCellDidSelectPlayingButton:(YWTrendsModel *)trens;

@end

@interface YWMovieCardTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWMovieCardTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) YWMovieCardModel *model;

+ (CGFloat)cellHeightWithModel:(YWMovieCardModel *)model withIndex:(NSInteger)index;

@end
