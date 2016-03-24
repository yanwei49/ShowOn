//
//  YWFocusTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kTrendsListType,
    kTrendsDetailType
} TrendsCellType;

@class YWTrendsModel;
@class YWFocusTableViewCell;
@protocol YWFocusTableViewCellDelegate <NSObject>

- (void)focusTableViewCellDidSelectCooperate:(YWFocusTableViewCell *)cell;
- (void)focusTableViewCellDidSelectPlay:(YWFocusTableViewCell *)cell;
- (void)focusTableViewCellDidSelectPlaying:(YWFocusTableViewCell *)cell;
- (void)focusTableViewCellDidSelectAvator:(YWFocusTableViewCell *)cell;

@end

@interface YWFocusTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWFocusTableViewCellDelegate> delegate;
@property (nonatomic, strong) YWTrendsModel  *trends;

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends type:(TrendsCellType)type;

@end
