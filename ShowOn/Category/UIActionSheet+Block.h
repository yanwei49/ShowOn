//
//  UIActionSheet+Block.h
//  GoFarm-V1.2.0
//
//  Created by David Yu on 20/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Block)

-(void) clickedCancel:(void (^)())block;
-(void) clickedButtonAtIndex:(void (^)(NSInteger buttonIndex))block;

@end
