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

@end
