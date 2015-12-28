//
//  YWFocusTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kMovieListType,
    kMovieDetailType
} MovieCellType;

@class YWMovieModel;
@class YWFocusTableViewCell;
@protocol YWFocusTableViewCellCellDelegate <NSObject>

- (void)focusTableViewCellDidSelectCooperate:(YWFocusTableViewCell *)cell;
- (void)focusTableViewCellDidSelectPlay:(YWFocusTableViewCell *)cell;

@end

@interface YWFocusTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWFocusTableViewCellCellDelegate> delegate;
@property (nonatomic, strong) YWMovieModel  *movie;

+(CGFloat)cellHeightWithMovie:(YWMovieModel *)movie type:(MovieCellType)type;

@end
