//
//  YWHotCollectionViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWHotCollectionViewCell;
@protocol YWHotCollectionViewCellDelegate <NSObject>

- (void)hotCollectionViewCellDidSelectSupport:(YWHotCollectionViewCell *)cell;

@end

@interface YWHotCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<YWHotCollectionViewCellDelegate> delegate;

@end
