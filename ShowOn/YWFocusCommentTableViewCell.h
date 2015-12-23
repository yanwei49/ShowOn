//
//  YWFocusCommentTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/16.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWTrendsModel;
@interface YWFocusCommentTableViewCell : UITableViewCell

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends;

@end
