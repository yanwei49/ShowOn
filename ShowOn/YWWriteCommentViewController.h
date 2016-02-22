//
//  YWWriteCommentViewController.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/27.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@class YWTrendsModel;
@class YWCommentModel;
@class YWMovieTemplateModel;
@interface YWWriteCommentViewController : YWBaseViewController

@property (nonatomic, strong) YWTrendsModel *trends;
@property (nonatomic, strong) YWCommentModel *comment;
@property (nonatomic, strong) YWMovieTemplateModel *template;

@end
