//
//  YWTemplateCollectionViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWMovieTemplateModel;
@class YWSubsectionVideoModel;
@class YWTemplateCollectionViewCell;
@protocol YWTemplateCollectionViewCellDelegate <NSObject>

- (void)templateCollectionViewCellRecorderDown:(YWTemplateCollectionViewCell *)cell;

@end
@interface YWTemplateCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGFloat viewAlpha;
@property (nonatomic, assign) NSInteger state; //(0:初始状态  1:正在录制，播放   2:录制完成)
@property (nonatomic, strong) YWMovieTemplateModel *template;
@property (nonatomic, strong) YWSubsectionVideoModel *subsectionVideo;
@property (nonatomic, assign) id<YWTemplateCollectionViewCellDelegate> delegate;
//@property (nonatomic, assign) BOOL progressHiddenState;

//开始录制动画
- (void)startRecorderAnimationWithDuration:(CGFloat)time;

@end
