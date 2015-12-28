//
//  YWFocusCommentTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/16.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWCommentModel;
@interface YWFocusCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) YWCommentModel *comment;

+(CGFloat)cellHeightWithComment:(YWCommentModel *)comment;

@end
