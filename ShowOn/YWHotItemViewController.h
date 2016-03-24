//
//  YWHotItemViewController.h
//  ShowOn
//
//  Created by 颜魏 on 16/1/12.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@class YWMovieTemplateModel;
@interface YWHotItemViewController : YWBaseViewController

@property (nonatomic, strong) YWMovieTemplateModel *template;
@property (nonatomic, assign) NSInteger segSelectIndex;

@end
