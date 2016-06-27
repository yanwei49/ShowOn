//
//  UIView+Boxing.h
//  GoFarm-V1.2.0
//
//  Created by David Yu on 8/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kTop,
    kLeft,
    kBottom,
    kRight
} BoxingOrientation;

@interface UIView (Boxing)

- (void)addBoxWithOrientation:(BoxingOrientation)orientation withSize:(CGFloat)size;   //给指定方向加边框
- (void)addBoxWithOrientations:(NSArray *)orientations withSize:(CGFloat)size;         //给数组内的指定方向加边框

@end
