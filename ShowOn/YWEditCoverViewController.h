//
//  YWEditCoverViewController.h
//  ShowOn
//
//  Created by David Yu on 25/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@class YWTrendsModel;
@class YWMovieTemplateModel;
@interface YWEditCoverViewController : YWBaseViewController

//@property (nonatomic, strong) NSArray *recorderMovies;
@property (nonatomic, strong) YWTrendsModel *trends;
@property (nonatomic, strong) YWMovieTemplateModel *template;
@property (nonatomic, assign) BOOL recorderState;

@end
