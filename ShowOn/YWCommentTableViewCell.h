//
//  YWCommentTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWCommentModel;
@interface YWCommentTableViewCell : UITableViewCell

+ (CGFloat)cellHeightForMode:(YWCommentModel *)model;

@end
