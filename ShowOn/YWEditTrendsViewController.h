//
//  YWEdithTrendsViewController.h
//  ShowOn
//
//  Created by David Yu on 25/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@class YWTrendsModel;
@class YWMovieTemplateModel;
@interface YWEditTrendsViewController : YWBaseViewController

@property (nonatomic, strong) UIImage *image;
//@property (nonatomic, strong) NSArray *recorderMovies;
@property (nonatomic, strong) YWTrendsModel *trends;
@property (nonatomic, strong) YWMovieTemplateModel *template;
@property (nonatomic, assign) BOOL recorderState;

@end
