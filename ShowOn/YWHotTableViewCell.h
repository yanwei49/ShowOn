//
//  YWHotCollectionViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieTemplateModel;
@class YWHotTableViewCell;
@protocol YWHotTableViewCellDelegate <NSObject>

- (void)hotTableViewCellDidSelectPlay:(YWHotTableViewCell *)cell;

@end
@interface YWHotTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWHotTableViewCellDelegate> delegate;
@property (nonatomic, strong) YWMovieTemplateModel *template;

@end
