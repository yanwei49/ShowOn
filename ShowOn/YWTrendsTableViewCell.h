//
//  YWTrendsTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWTrendsModel;
@class YWTrendsTableViewCell;
@protocol YWTrendsTableViewCellDelegate <NSObject>

- (void)trendsTableViewCellDidSelectSupportButton:(YWTrendsTableViewCell *)cell;

@end
@interface YWTrendsTableViewCell : UITableViewCell

@property (nonatomic, strong) YWTrendsModel *trends;
@property (nonatomic, assign) id<YWTrendsTableViewCellDelegate> delegate;

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends;

@end
