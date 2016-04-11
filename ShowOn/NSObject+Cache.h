//
//  NSObject+Cache.h
//  GoFarm-V1.2.0
//
//  Created by David Yu on 8/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Cache)

@property (nonatomic, copy) void(^clearSuccess)();
+ (CGFloat)obtainCacheSize;     //获取缓存大小
+ (void)clearCache:(void (^)())clearSuccess;             //清理缓存

@end
