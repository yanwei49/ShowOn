//
//  NSObject+Cache.m
//  GoFarm-V1.2.0
//
//  Created by David Yu on 8/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "NSObject+Cache.h"

@implementation NSObject (Cache)

+ (CGFloat)obtainCacheSize {
    CGFloat size = 0;
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/ImageCaches"];
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSString *imageSize = [dict objectForKey:NSFileSize];
    size += imageSize.floatValue;
    
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *p in files) {
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        size += [self folderSizeAtPath:path];
    }

    return size;
}

+ (void)clearCache:(void (^)())clearSuccess {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        clearSuccess();
    });
}

//单个文件的大小
- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

@end
