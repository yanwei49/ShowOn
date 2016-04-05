//
//  YWMovieCallingCardCollectionViewCell.h
//  ShowOn
//
//  Created by David Yu on 5/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieCallingCardCollectionViewCell;
@protocol YWMovieCallingCardCollectionViewCellDelegate <NSObject>

- (void)movieCallingCardCollectionViewCellStateButtonWithSelected:(YWMovieCallingCardCollectionViewCell *)cell;

@end

@interface YWMovieCallingCardCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<YWMovieCallingCardCollectionViewCellDelegate> delegate;

@end
