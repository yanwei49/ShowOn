//
//  YWFocusTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieModel;
@interface YWFocusTableViewCell : UITableViewCell

+(CGFloat)cellHeightWithMovie:(YWMovieModel *)movie;

@end
