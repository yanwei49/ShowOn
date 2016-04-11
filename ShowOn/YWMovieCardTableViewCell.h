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
@protocol YWMovieCardTableViewCellDelegate <NSObject>

- (void)movieCardTableViewCellDidSelectPlayingButton:(YWMovieCardTableViewCell *)cell;

@end

@interface YWMovieCardTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWMovieCardTableViewCellDelegate> delegate;
@property (nonatomic, strong) YWMovieCardModel *model;

+ (CGFloat)cellHeightWithModel:(YWMovieCardModel *)model;

@end
