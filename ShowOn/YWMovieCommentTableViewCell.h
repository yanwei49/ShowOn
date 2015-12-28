//
//  YWMovieCommentTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/27.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWCommentModel;
@class YWMovieCommentTableViewCell;
@protocol YWMovieCommentTableViewCellDelegate <NSObject>

- (void)movieCommentTableViewCellDidSelectSupport:(YWMovieCommentTableViewCell *)cell;

@end
@interface YWMovieCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) YWCommentModel *comment;
@property (nonatomic, assign) id<YWMovieCommentTableViewCellDelegate> delegate;

+(CGFloat)cellHeightWithComment:(YWCommentModel *)comment;

@end
