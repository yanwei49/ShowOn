//
//  YWTemplatListTableViewCell.h
//  ShowOn
//
//  Created by David Yu on 14/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieTemplateModel;
@class YWTemplateListTableViewCell;
@protocol YWTemplateListTableViewCellDelegate <NSObject>

- (void)templateListTableViewCellDidSelectPlay:(YWTemplateListTableViewCell *)cell;

@end
@interface YWTemplateListTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWTemplateListTableViewCellDelegate> delegate;
@property (nonatomic, strong) YWMovieTemplateModel  *template;

@end
