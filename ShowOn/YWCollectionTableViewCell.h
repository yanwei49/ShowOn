//
//  YWCollectionTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWTrendsModel;
@class YWCollectionTableViewCell;
@protocol YWCollectionTableViewCellDelegate <NSObject>

- (void)collectionTableViewCellDidSelectCooperate:(YWCollectionTableViewCell *)cell;
- (void)collectionTableViewCellDidSelectPlay:(YWCollectionTableViewCell *)cell;
- (void)collectionTableViewCellDidSelectPlaying:(YWCollectionTableViewCell *)cell;

@end

@interface YWCollectionTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWCollectionTableViewCellDelegate> delegate;
@property (nonatomic, strong) YWTrendsModel  *trends;

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends;

@end
