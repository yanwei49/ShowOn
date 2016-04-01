//
//  YWMovieRecorder.m
//  ShowOn
//
//  Created by David Yu on 9/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWMovieRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YWSubsectionVideoModel.h"

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface YWMovieRecorder ()<AVCaptureFileOutputRecordingDelegate>//视频文件输出代理

@end

@implementation YWMovieRecorder
{
    AVCaptureSession           *_captureSession;//负责输入和输出设备之间的数据传递
    AVCaptureDeviceInput       *_captureDeviceInput;//负责从AVCaptureDevice获得输入数据
    AVCaptureMovieFileOutput   *_captureMovieFileOutput;//视频输出流
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;//相机拍摄预览图层
    BOOL                        _enableRotation;//是否允许旋转（注意在视频录制过程中禁止屏幕旋转）
    CGRect                     *_lastBounds;//旋转的前大小
    UIBackgroundTaskIdentifier  _backgroundTaskIdentifier;//后台任务标识
    UIView                     *_backView;
    UILabel                    *_timeLabel;
    NSTimer                    *_timer;
    UIButton                   *_playButton; //播放/暂停按钮
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubViews];
    }
    
    return self;
}

- (void)initSubViews {
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-30, self.bounds.size.height/2-30, 60, 60)];
    [_playButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
    
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];//取得前置摄像头
    if (!captureDevice) {
        DebugLog(@"取得前置摄像头时出现问题.");
        return;
    }
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        DebugLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        DebugLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc] init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
//    _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    CALayer *layer = self.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
    
    _enableRotation=YES;
    [self addNotificationToCaptureDevice:captureDevice];
    
    _backView = [[UIView alloc] initWithFrame:self.bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.7;
    [self addSubview:_backView];
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-30, self.bounds.size.height/2-30, 60, 60)];
    [_playButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
}

- (void)startRunning {
    [_captureSession startRunning];
}

- (void)stopRunning {
    [_captureSession stopRunning];
}

- (void)actionPlay {
    if (_model.subsectionRecorderVideoUrl.length) {
        NSLog(@"已经录制完了");
    }else {
        _playButton.hidden = YES;
        _timeLabel = [[UILabel alloc] initWithFrame:_playButton.frame];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"3";
        _timeLabel.font = [UIFont boldSystemFontOfSize:50];
        [self addSubview:_timeLabel];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:YES];
    }
}

- (void)startRecorder {
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    if (![_captureMovieFileOutput isRecording]) {
        _backView.hidden = YES;
        if ([_delegate respondsToSelector:@selector(movieRecorderBegin:)]) {
            [_delegate movieRecorderBegin:self];
        }
        _enableRotation=NO;
        //如果支持多任务则则开始多任务
        if ([[UIDevice currentDevice] isMultitaskingSupported]) {
            _backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        }
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[_captureVideoPreviewLayer connection].videoOrientation;
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];

        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        [_captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
    else{
        _backView.hidden = NO;
        [_captureMovieFileOutput stopRecording];//停止录制
    }
}

- (void)delayMethod {
    NSInteger cnt = _timeLabel.text.integerValue;
    cnt--;
    _timeLabel.text = [NSString stringWithFormat:@"%ld", (long)cnt];
    if (!cnt) {
        [_timeLabel removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
        [self startRecorder];
    }
}

- (void)changeCamera {
    AVCaptureDevice *currentDevice=[_captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront) {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [_captureSession beginConfiguration];
    //移除原有输入对象
    [_captureSession removeInput:_captureDeviceInput];
    //添加新的输入对象
    if ([_captureSession canAddInput:toChangeDeviceInput]) {
        [_captureSession addInput:toChangeDeviceInput];
        _captureDeviceInput = toChangeDeviceInput;
    }
    //提交会话配置
    [_captureSession commitConfiguration];
}

#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    DebugLog(@"开始录制...");
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    DebugLog(@"视频录制完成.");
    _model.recorderVideoUrl = outputFileURL;
    if ([_delegate respondsToSelector:@selector(movieRecorderDown:)]) {
        [_delegate movieRecorderDown:self];
    }
    //视频录入完成之后在后台将视频存储到相簿
    _enableRotation=YES;
    _playButton.hidden = NO;
    _backView.hidden = NO;
    UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier = _backgroundTaskIdentifier;
    _backgroundTaskIdentifier=UIBackgroundTaskInvalid;
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            DebugLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        }
        if (lastBackgroundTaskIdentifier!=UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:lastBackgroundTaskIdentifier];
        }
        DebugLog(@"成功保存视频到相簿.");
    }];
    
}

#pragma mark - 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    DebugLog(@"设备已连接...");
}

/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    DebugLog(@"设备已断开.");
}

/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
//    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    DebugLog(@"会话发生错误.");
}

#pragma mark - 私有方法
/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [_captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        DebugLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

@end
