//
//  YWHotView.h
//  ShowOn
//
//  Created by David Yu on 12/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWHotView;
@protocol YWHotViewDelegate <NSObject>

- (void)hotViewDidSelectItemWithIndex:(NSInteger)index;

@end
@interface YWHotView : UIView

@property (nonatomic, assign) id<YWHotViewDelegate> delegate;
+ (YWHotView *)shareInstance;

@end
