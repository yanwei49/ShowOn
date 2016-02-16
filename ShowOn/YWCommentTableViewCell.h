//
//  YWCommentTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWCommentModel;
@class YWCommentTableViewCell;
@protocol YWCommentTableViewCellDelegate <NSObject>

- (void)commentTableViewCellDidSelectPlay:(YWCommentTableViewCell *)cell;

@end
@interface YWCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) YWCommentModel *comment;
@property (nonatomic, assign) id<YWCommentTableViewCellDelegate> delegate;

+ (CGFloat)cellHeightForMode:(YWCommentModel *)model;

@end
