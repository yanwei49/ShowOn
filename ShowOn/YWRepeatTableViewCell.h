//
//  YWRepeatTableViewCell.h
//  ShowOn
//
//  Created by David Yu on 22/3/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWTrendsModel;
@class YWRepeatTableViewCell;
@protocol YWRepeatTableViewCellDelegate <NSObject>

- (void)repeatTableViewCellDidSelectCooperate:(YWRepeatTableViewCell *)cell;
- (void)repeatTableViewCellDidSelectPlay:(YWRepeatTableViewCell *)cell;
- (void)repeatTableViewCellDidSelectPlaying:(YWRepeatTableViewCell *)cell;
- (void)repeatTableViewCellDidSelectAvator:(YWRepeatTableViewCell *)cell;

@end


@interface YWRepeatTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWRepeatTableViewCellDelegate> delegate;
@property (nonatomic, strong) YWTrendsModel  *trends;

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends;

@end
