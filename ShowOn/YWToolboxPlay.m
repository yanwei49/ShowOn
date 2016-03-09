//
//  YWToolboxPlay.m
//  ShowOn
//
//  Created by David Yu on 9/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWToolboxPlay.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation YWToolboxPlay
{
    CAShapeLayer   *_shapLayer;
    UILabel        *_numsLabel;
    NSTimer        *_timer;
    NSInteger       _cnt;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubObject];
        [self createTimer];
    }
    
    return self;
}

- (void)createSubObject {
    _shapLayer = [CAShapeLayer layer];
    _shapLayer.frame = [UIScreen mainScreen].bounds;
    _shapLayer.backgroundColor = SeparatorColor.CGColor;
    _shapLayer.opacity = 0.5;
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:_shapLayer];
    
    _numsLabel = [[UILabel alloc] init];
    _numsLabel.textAlignment = NSTextAlignmentCenter;
    _numsLabel.center = _shapLayer.position;
    _numsLabel.bounds = CGRectMake(0, 0, kScreenWidth, 100);
    _numsLabel.font = [UIFont boldSystemFontOfSize:40];
    [_shapLayer addSublayer:_numsLabel.layer];
    _shapLayer.hidden = YES;
    _numsLabel.hidden = YES;
}

/**
 *  播放音效文件
 *
 *  @param name 音频文件名称
 */
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
}

- (void)createTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
}

- (void)run {
    if (_cnt == 1) {
        _numsLabel.hidden = YES;
        [self playSoundEffect:@"videoRing.caf"];
    }else if (_cnt == 0) {
        _timer.fireDate = [NSDate distantFuture];
        [self playEnd];
    }else {
        _numsLabel.text = [NSString stringWithFormat:@"%ld", (long)_cnt-1];
    }
    _cnt--;
}

- (void)play {
    _cnt = 4;
    _shapLayer.hidden = NO;
    _numsLabel.hidden = NO;
    _timer.fireDate = [NSDate distantPast];
}

- (void)playEnd {
    _shapLayer.hidden = YES;
    _numsLabel.hidden = YES;
    if ([_delegate respondsToSelector:@selector(toolboxPlayEnd)]) {
        [_delegate toolboxPlayEnd];
    }
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
//    NSLog(@"播放完成...");
    
}


@end
