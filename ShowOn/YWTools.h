//
//  YWTools.h
//  ShowOn
//
//  Created by David Yu on 4/3/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWTools : NSObject

//根据视频播放地址获取该时间点的缩略图
+(UIImage *)thumbnailImageRequestUrl:(NSURL *)url time:(CGFloat )timeBySecond;

//压缩图片
+ (UIImage *)image:(UIImage*)image scaledToSize:(CGSize)newSize;

//裁剪图片
+ (UIImage *)cutImage:(UIImage*)image withRect:(CGRect)rect;

//根据视频url获取视频时间长度（转换成分：秒格式）
+ (NSString *)timMinuteStringWithUrl:(NSString *)url;

//根据视频url获取视频时间长度（转换秒）
+ (NSString *)timSecondStringWithUrl:(NSString *)url;

@end
