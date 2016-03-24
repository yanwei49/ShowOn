//
//  YWTemplateTrendsTableViewCell.h
//  ShowOn
//
//  Created by David Yu on 18/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWTrendsModel;
@class YWTemplateTrendsTableViewCell;
@protocol YWTemplateTrendsTableViewCellDelegate <NSObject>

- (void)templateTrendsTableViewCellDidSelectCooperate:(YWTemplateTrendsTableViewCell *)cell;
- (void)templateTrendsTableViewCellDidSelectPlay:(YWTemplateTrendsTableViewCell *)cell;
- (void)templateTrendsTableViewCellDidSelectPlaying:(YWTemplateTrendsTableViewCell *)cell;
- (void)templateTrendsTableViewCellDidSelectAvator:(YWTemplateTrendsTableViewCell *)cell;

@end


@interface YWTemplateTrendsTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWTemplateTrendsTableViewCellDelegate> delegate;
@property (nonatomic, strong) YWTrendsModel  *trends;

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends;

@end
