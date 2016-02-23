//
//  YWHotView.h
//  ShowOn
//
//  Created by David Yu on 12/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWHotView;
@class YWMovieTemplateModel;
@protocol YWHotViewDelegate <NSObject>

- (void)hotViewDidSelectItemWithTemplate:(YWMovieTemplateModel *)template;
- (void)hotViewDidSelectPlayItemWithTemplate:(YWMovieTemplateModel *)template;

@end
@interface YWHotView : UIView

@property (nonatomic, assign) id<YWHotViewDelegate> delegate;
@property (nonatomic, strong) NSArray  *dataSource;
+ (YWHotView *)shareInstance;

@end
