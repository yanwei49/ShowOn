//
//  YWTrendsCategoryView.h
//  ShowOn
//
//  Created by David Yu on 16/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWTrendsCategoryView;
@protocol YWTrendsCategoryViewDelegate <NSObject>

- (void)trendsCategoryView:(YWTrendsCategoryView *)view didSelectCategoryWithIndex:(NSInteger)index;

@end
@interface YWTrendsCategoryView : UIView

@property (nonatomic, assign) id<YWTrendsCategoryViewDelegate> delegate;
@property (nonatomic, strong) NSArray *categoryArray;

@end
