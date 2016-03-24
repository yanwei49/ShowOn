//
//  YWRepeatDetailTableViewCell.h
//  ShowOn
//
//  Created by David Yu on 22/3/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kRepeatTrendsListType,
    kRepeatTrendsDetailType
} RepeatTrendsCellType;

@class YWTrendsModel;
@class YWRepeatDetailTableViewCell;
@protocol YWRepeatDetailTableViewCellDelegate <NSObject>

- (void)repeatDetailTableViewCellDidSelectCooperate:(YWRepeatDetailTableViewCell *)cell;
- (void)repeatDetailTableViewCellDidSelectPlay:(YWRepeatDetailTableViewCell *)cell;
- (void)repeatDetailTableViewCellDidSelectPlaying:(YWRepeatDetailTableViewCell *)cell;
- (void)repeatDetailTableViewCellDidSelectAvator:(YWRepeatDetailTableViewCell *)cell;

@end

@interface YWRepeatDetailTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWRepeatDetailTableViewCellDelegate> delegate;
@property (nonatomic, strong) YWTrendsModel  *trends;

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends type:(RepeatTrendsCellType)type;

@end
