//
//  YWKeyboardHeadView.h
//  ShowOn
//
//  Created by David Yu on 16/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWKeyboardHeadViewDelegate <NSObject>

- (void)keyboardHeadViewButtonOnClick;

@end

@interface YWKeyboardHeadView : UIView

@property (nonatomic, strong) id<YWKeyboardHeadViewDelegate> delegate;

@end
