//
//  YWCutImageViewController.h
//  ShowOn
//
//  Created by 颜魏 on 16/3/5.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@protocol YWCutImageViewControllerDelegate <NSObject>

- (void)cutImageViewControllerCutImage:(UIImage *)cutImage;

@end
@interface YWCutImageViewController : YWBaseViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) id<YWCutImageViewControllerDelegate> delegate;

@end
