//
//  YWSearchTemplateTableViewCell.h
//  ShowOn
//
//  Created by David Yu on 25/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieTemplateModel;
@protocol YWSearchTemplateTableViewCellDelegate <NSObject>

- (void)searchTemplateTableViewCellDidSelectCellWithTemplate:(YWMovieTemplateModel *)template;

@end
@interface YWSearchTemplateTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YWSearchTemplateTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSArray *templates;

@end
