//
//  YWSearchCollectionReusableView.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWSearchCollectionReusableView;
@protocol YWSearchCollectionReusableViewDelegate <NSObject>

- (void)searchCollectionReusableView:(YWSearchCollectionReusableView *)view didSelectItemWithIndex:(NSInteger)index;
- (void)searchCollectionReusableViewDidSelectSearchButton:(YWSearchCollectionReusableView *)view;

@end

@interface YWSearchCollectionReusableView : UICollectionReusableView

@property (nonatomic, assign) BOOL itemShowState;
@property (nonatomic, assign) id<YWSearchCollectionReusableViewDelegate> delegate;

@end
