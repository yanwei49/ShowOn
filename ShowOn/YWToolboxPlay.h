//
//  YWToolboxPlay.h
//  ShowOn
//
//  Created by David Yu on 9/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWToolboxPlay;
@protocol YWToolboxPlayDelegate <NSObject>

- (void)toolboxPlayEnd;

@end

@interface YWToolboxPlay : NSObject

@property (nonatomic, assign) id<YWToolboxPlayDelegate> delegate;

//+ (YWToolboxPlay *)shareInstance;
- (void)play;

@end
