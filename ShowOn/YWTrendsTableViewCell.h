//
//  YWTrendsTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWTrendsModel;
@interface YWTrendsTableViewCell : UITableViewCell

+(CGFloat)cellHeightWithTrends:(YWTrendsModel *)trends;

@end
