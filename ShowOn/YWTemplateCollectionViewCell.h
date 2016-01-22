//
//  YWTemplateCollectionViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieTemplateModel;
@interface YWTemplateCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGFloat viewAlpha;
@property (nonatomic, strong) YWMovieTemplateModel *template;

@end
