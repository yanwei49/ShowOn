//
//  YWTools.m
//  ShowOn
//
//  Created by David Yu on 4/3/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWTools.h"
#import <AVFoundation/AVFoundation.h>

@implementation YWTools

/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */
+ (UIImage *)thumbnailImageRequestUrl:(NSURL *)url time:(CGFloat )timeBySecond {
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
    
    CGImageRelease(cgImage);
    
    return image;
}

//压缩图片
+ (UIImage *)image:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

//裁剪图片
+ (UIImage *)cutImage:(UIImage*)image withRect:(CGRect)rect {
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (rect.size.width / rect.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * rect.size.height / rect.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * rect.size.width / rect.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}

+ (NSString *)timMinuteStringWithUrl:(NSString *)url {
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:[NSURL URLWithString:urlStr]];
    NSInteger time = (NSInteger)CMTimeGetSeconds(urlAsset.duration);
    NSString *timeString = [NSString stringWithFormat:@"%2ld分%ld秒", (long)time/60, (long)time%60];
    
    return timeString;
}

+ (NSString *)timSecondStringWithUrl:(NSString *)url {
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:[NSURL URLWithString:urlStr]];
    NSInteger time = (NSInteger)CMTimeGetSeconds(urlAsset.duration);
    NSString *timeString = [NSString stringWithFormat:@"%lds", (long)time];
    
    return timeString;
}

@end
