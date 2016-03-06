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
@property (nonatomic, assign) NSInteger type;  //(1.评论动态   2.回复动态评论   3.转发  4.评论模板  5.回复模板评论)

@end
