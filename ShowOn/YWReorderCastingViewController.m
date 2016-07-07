//
//  YWReorderCastingViewController.m
//  ShowOn
//
//  Created by David Yu on 6/5/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWReorderCastingViewController.h"
#import "YWEditCoverViewController.h"
#import "YWMovieRecorder.h"
#import "YWMoviePlayView.h"
#import "YWMovieModel.h"
#import "YWUserModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MPMoviePlayerViewController+Rotation.h"
#import "YWTools.h"

#define kRecordAudioFile @"myRecord.caf"

@interface YWReorderCastingViewController ()<YWMovieRecorderDelegate, YWMoviePlayViewDelegate,AVAudioRecorderDelegate>

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）

@end

@implementation YWReorderCastingViewController
{
    YWMovieRecorder     *_recorderView;
    YWMoviePlayView     *_downPlayView;
    YWMoviePlayView     *_playView;
    UIButton            *_restartButton;
    UIButton            *_changeButton;
    NSURL               *_audioUrl;
    UIImageView         *_coverImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录制个人简介";
    [self createRightItemWithTitle:@"封面"];
    
    [self createSubViews];
    [self setAudioSession];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_recorderView stopRunning];
    [_playView stop];
    [_downPlayView stop];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_recorderView startRunning];
}

#pragma mark - subview
- (void)createSubViews {
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    sv.backgroundColor = Subject_color;
    [self.view addSubview:sv];
    sv.contentSize = CGSizeMake(kScreenWidth, 250*3+30);
    
    _playView = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 250) playUrl:_user.casting.movieUrl];
    _playView.backgroundColor = Subject_color;
    _playView.layer.masksToBounds = YES;
    _playView.delegate = self;
    _playView.layer.cornerRadius = 5;
    _playView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
    _playView.layer.borderWidth = 1;
    [sv addSubview:_playView];
    
    _recorderView = [[YWMovieRecorder alloc] initWithFrame:CGRectMake(5, 10+250, kScreenWidth-10, 250)];
    _recorderView.backgroundColor = Subject_color;
    _recorderView.layer.masksToBounds = YES;
    _recorderView.layer.cornerRadius = 5;
    _recorderView.delegate = self;
    _recorderView.movie = _user.casting;
    _recorderView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
    _recorderView.layer.borderWidth = 1;
    [sv addSubview:_recorderView];
    
    _restartButton = [[UIButton alloc] init];
    _restartButton.backgroundColor = Subject_color;
    [_restartButton setTitle:@"重新拍摄" forState:UIControlStateNormal];
    [_restartButton setImage:[UIImage imageNamed:@"red_point_button.png"] forState:UIControlStateNormal];
    [_restartButton addTarget:self action:@selector(actionReStart) forControlEvents:UIControlEventTouchUpInside];
    [_recorderView addSubview:_restartButton];
    [_restartButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_recorderView.mas_right).offset(-5);
        make.height.offset(20);
        make.top.equalTo(_recorderView.mas_top).offset(5);
    }];
    
    _changeButton = [[UIButton alloc] init];
    _changeButton.backgroundColor = Subject_color;
    [_changeButton setTitle:@"切换" forState:UIControlStateNormal];
    [_changeButton setImage:[UIImage imageNamed:@"change_shot_button.png"] forState:UIControlStateNormal];
    [_changeButton addTarget:self action:@selector(actionChange:) forControlEvents:UIControlEventTouchUpInside];
    [_recorderView addSubview:_changeButton];
    [_changeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_recorderView.mas_left).offset(5);
        make.height.offset(20);
        make.top.equalTo(_recorderView.mas_top).offset(5);
    }];
    
    _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15+250*2, kScreenWidth-10, 250)];
    _coverImageView.backgroundColor = RGBColor(30, 30, 30);
    _coverImageView.layer.masksToBounds = YES;
    _coverImageView.layer.cornerRadius = 5;
    _coverImageView.userInteractionEnabled = YES;
    [sv addSubview:_coverImageView];
//    [_coverImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(65);
//        make.left.offset(5);
//        make.right.offset(-5);
//        make.height.offset(200);
//    }];
    
    UIButton *playButton = [[UIButton alloc] init];
    [playButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
    [_coverImageView addSubview:playButton];
    [playButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_coverImageView.mas_centerY);
        make.centerX.equalTo(_coverImageView.mas_centerX);
        make.width.height.offset(50);
    }];

//    _downPlayView = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(5, 15+250*2, kScreenWidth-10, 250) playUrl:@""];
//    _downPlayView.backgroundColor = Subject_color;
//    _downPlayView.layer.masksToBounds = YES;
//    _downPlayView.layer.cornerRadius = 5;
//    _downPlayView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
//    _downPlayView.layer.borderWidth = 1;
//    [sv addSubview:_downPlayView];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    if (_user.casting.movieRecorderUrl) {
        YWEditCoverViewController *vc = [[YWEditCoverViewController alloc] init];
        vc.user = _user;
        vc.isCasting = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self showAlterWithTitle:@"请录制视频"];
    }
}

- (void)actionReStart {
    _downPlayView.url = [NSURL URLWithString:@""];
    _user.casting.movieRecorderUrl = nil;
}

- (void)actionChange:(UIButton *)button {
    [_recorderView changeCamera];
}

- (void)actionPlay {
    if ([self checkNewWorkIsWifi]) {
        MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:_user.casting.movieRecorderUrl];
        [moviePlayerViewController rotateVideoViewWithDegrees:90];
        [self presentViewController:moviePlayerViewController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"你当前网络不是WiFi，是否播放" message:nil delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alter show];
        [alter clickedButtonAtIndex:^(NSInteger buttonIndex) {
            MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:_user.casting.movieRecorderUrl];
            [moviePlayerViewController rotateVideoViewWithDegrees:90];
            [self presentViewController:moviePlayerViewController animated:YES completion:nil];
        }];
    }
}

#pragma mark - YWMovieRecorderDelegate
- (void)movieRecorderDown:(YWMovieRecorder *)view {
    _changeButton.userInteractionEnabled = YES;
    _restartButton.userInteractionEnabled = YES;
    _downPlayView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    _playView.volum = 1;
    _downPlayView.url = view.movie.movieRecorderUrl;
    [self stop];
}

- (void)movieRecorderBegin:(YWMovieRecorder *)view {
    _changeButton.userInteractionEnabled = NO;
    _restartButton.userInteractionEnabled = NO;
    _downPlayView.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [_playView play];
    _playView.volum = 0;
    [self record];
}

#pragma mark - YWMoviePlayViewDelegate
- (void)moviePlayViewPlayDown:(YWMoviePlayView *)view {
    [_recorderView startRecorder];
}

#pragma mark - 私有方法
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    DebugLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    _audioUrl = url;
    
    return url;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

- (void)record {
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
}

- (void)stop {
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [self mergeAndSave];
    DebugLog(@"录音完成!");
}

//合并
- (void)mergeAndSave {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = NO;
        [SVProgressHUD showWithStatus:@"合成中"];
    });
    AVAsset *_medioAsset1 = [AVAsset assetWithURL:_recorderView.movie.movieRecorderUrl];
    AVAsset *_audioAsset = [AVAsset assetWithURL:_audioUrl];
    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // 2 - Video track
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, _medioAsset1.duration) ofTrack:[[_medioAsset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    // 3 - Audio track
    AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(_medioAsset1.duration, _audioAsset.duration)) ofTrack:[[_audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD showSuccessWithStatus:@"合成成功"];
            [self exportDidFinish:exporter];
            _user.casting.movieRecorderUrl = exporter.outputURL;
            _coverImageView.image = [self rotation:[YWTools thumbnailImageRequestUrl:_user.casting.movieRecorderUrl time:0]];
        });
    }];
}

- (UIImage *)rotation:(UIImage *)aImage {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
    transform = CGAffineTransformRotate(transform, M_PI_2);
    transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
    transform = CGAffineTransformScale(transform, -1, 2);
    
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                    DebugLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
                }else {
                    DebugLog(@"成功保存视频到相簿.");
                }
            }];
        }
    }
}




@end
