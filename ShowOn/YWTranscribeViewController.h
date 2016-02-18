//
//  YWTranscribeViewController.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@class YWTrendsModel;
@class YWMovieTemplateModel;
@interface YWTranscribeViewController : YWBaseViewController

@property (nonatomic, strong) YWMovieTemplateModel *template;
@property (nonatomic, strong) YWTrendsModel *trends;

@end
