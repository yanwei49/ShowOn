//
//  YWPreviewViewController.m
//  ShowOn
//
//  Created by David Yu on 16/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWPreviewViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMoviePlayerViewController+Rotation.h"
#import "YWSubsectionVideoModel.h"
#import "YWMovieTemplateModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "YWTools.h"

@interface YWPreviewViewController ()

@end

@implementation YWPreviewViewController
{
    NSURL               *_movieUrl;
    UIImageView         *_coverImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = @"预览";

    _movieUrl = [self movieMerge];

    [self createSubViews];
}

- (void)actionPlay {
    if ([self checkNewWorkIsWifi]) {
        MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:_movieUrl];
        //    [moviePlayerViewController rotateVideoViewWithDegrees:90];
        [self presentViewController:moviePlayerViewController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"你当前网络不是WiFi，是否播放" message:nil delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alter show];
        [alter clickedButtonAtIndex:^(NSInteger buttonIndex) {
            MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:_movieUrl];
            //    [moviePlayerViewController rotateVideoViewWithDegrees:90];
            [self presentViewController:moviePlayerViewController animated:YES completion:nil];
        }];
    }
}

- (void)createSubViews {
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.backgroundColor = RGBColor(30, 30, 30);
    _coverImageView.layer.masksToBounds = YES;
    _coverImageView.layer.cornerRadius = 5;
    [self.view addSubview:_coverImageView];
    [_coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(65);
        make.left.offset(5);
        make.right.offset(-5);
        make.height.offset(200);
    }];

    UIButton *playButton = [[UIButton alloc] init];
    [playButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    [playButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_coverImageView.mas_centerY);
        make.centerX.equalTo(_coverImageView.mas_centerX);
        make.width.height.offset(100);
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


#pragma mark - private
- (NSURL *)movieMerge {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self mergeAndSaveCompletes:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"合成成功"];
                self.view.userInteractionEnabled = YES;
                _movieUrl = responseObject;
                _coverImageView.image = [YWTools thumbnailImageRequestUrl:_movieUrl time:0];
            });
            
            return responseObject;
        }];
    });
    return nil;
}

//合并
- (void)mergeAndSaveComplete:(NSURL * (^) (id responseObject))complete {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.userInteractionEnabled = NO;
        [SVProgressHUD showWithStatus:@"合成中"];
    });
    NSMutableArray *vedioAssets = [NSMutableArray array];
    NSMutableArray *audioAssets = [NSMutableArray array];
    for (NSInteger i=0; i<_template.templateSubsectionVideos.count; i++) {
        NSURL *movieUrl;
        NSURL *audioUrl;
        for (YWSubsectionVideoModel *model in _template.templateSubsectionVideos) {
            if (model.subsectionAudioUrl.length) {
                audioUrl = [NSURL URLWithString:model.subsectionAudioUrl];
            }
            if (model.subsectionVideoSort.integerValue == i+1) {
                if (model.recorderVideoUrl) {
                    movieUrl = model.recorderVideoUrl;
//                }else if(model.subsectionVideoUrl.length) {
//                    movieUrl = [NSURL URLWithString:model.subsectionVideoUrl];
                }else if (model.subsectionRecorderVideoUrl.length) {
                    movieUrl = [NSURL URLWithString:model.subsectionRecorderVideoUrl];
                }
                break;
            }
        }
        if (audioUrl) {
            AVAsset *asset = [AVAsset assetWithURL:movieUrl];
            [audioAssets addObject:asset];
        }
        if (!movieUrl) {
            break;
        }else {
            _movieUrl = movieUrl;
            AVAsset *asset = [AVAsset assetWithURL:movieUrl];
            [vedioAssets addObject:asset];
        }
    }
    if (vedioAssets.count<=1) {
        return;
    }
    //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    
    //VIDEO TRACK
    AVAsset *firstAsset = vedioAssets.firstObject;
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    //AUDIO TRACK
    AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //FIXING ORIENTATION//
    AVMutableVideoCompositionLayerInstruction *firstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
    AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
    BOOL  isFirstAssetPortrait_  = NO;
    CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
    if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)  {FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;}
    if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)  {FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;}
    if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {FirstAssetOrientation_ =  UIImageOrientationUp;}
    if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {FirstAssetOrientation_ = UIImageOrientationDown;}
    CGFloat FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.width;
    if(isFirstAssetPortrait_){
        FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.height;
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [firstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
    }else{
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [firstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
    }
    [firstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];

    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    NSMutableArray *othernextLayerInstructions = [NSMutableArray arrayWithObjects:firstlayerInstruction, nil];
    CMTime time = CMTimeAdd(kCMTimeZero, firstAsset.duration);
    for (NSInteger i=1; i<vedioAssets.count; i++) {
        AVAsset *nextAsset = vedioAssets[i];
        AVMutableCompositionTrack *nextTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [nextTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, nextAsset.duration) ofTrack:[[nextAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:time error:nil];
        //AUDIO TRACK
        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, nextAsset.duration) ofTrack:[[nextAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:time error:nil];
        time = CMTimeAdd(time, nextAsset.duration);
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *nextLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextTrack];
        AVAssetTrack *nextAssetTrack = [[nextAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation nextAssetOrientation_  = UIImageOrientationUp;
        BOOL  isSecondAssetPortrait_  = NO;
        CGAffineTransform secondTransform = nextAssetTrack.preferredTransform;
        if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {nextAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {nextAssetOrientation_ =  UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {nextAssetOrientation_ =  UIImageOrientationUp;}
        if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {nextAssetOrientation_ = UIImageOrientationDown;}
        CGFloat SecondAssetScaleToFitRatio = 320.0/nextAssetTrack.naturalSize.width;
        if(isSecondAssetPortrait_){
            SecondAssetScaleToFitRatio = 320.0/nextAssetTrack.naturalSize.height;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [nextLayerInstruction setTransform:CGAffineTransformConcat(nextAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:firstAsset.duration];
        }else{
            ;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [nextLayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(nextAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:firstAsset.duration];
        }
        [othernextLayerInstructions addObject:nextLayerInstruction];
    }
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, time);
    
    MainInstruction.layerInstructions = [NSArray arrayWithArray:othernextLayerInstructions];
    
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    MainCompositionInst.renderSize = CGSizeMake(320.0, 480.0);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"mergeVideo-%ld.mov",[[[NSUserDefaults standardUserDefaults] objectForKey:@"MOVIE_COUNT"] integerValue]+1]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", [[[NSUserDefaults standardUserDefaults] objectForKey:@"MOVIE_COUNT"] integerValue]+1] forKey:@"MOVIE_COUNT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.videoComposition = MainCompositionInst;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             complete(exporter.outputURL);
             [self exportDidFinish:exporter];
         });
     }];
}

/*!
 @method mergeAndExportVideosAtFileURLs:
 
 @param fileURLArray
 包含所有视频分段的文件URL数组，必须是[NSURL fileURLWithString:...]得到的
 
 @discussion
 将所有分段视频合成为一段完整视频，并且裁剪为正方形
 */
- (void)mergeAndSaveCompletes:(NSURL * (^) (id responseObject))complete {
    NSMutableArray *vedioAssets = [NSMutableArray array];
    NSMutableArray *fileURLArray = [NSMutableArray array];
    NSMutableArray *oFileURLArray = [NSMutableArray array];
    for (NSInteger i=0; i<_template.templateSubsectionVideos.count; i++) {
        NSURL *movieUrl;
        NSURL *audioUrl;
        NSURL *oMovieUrl;
        for (YWSubsectionVideoModel *model in _template.templateSubsectionVideos) {
            if (model.subsectionAudioUrl.length) {
                audioUrl = [NSURL URLWithString:model.subsectionAudioUrl];
            }
            if (model.subsectionVideoSort.integerValue == i+1) {
                if (model.recorderVideoUrl) {
                    movieUrl = model.recorderVideoUrl;
                    NSString *urlStr = [model.subsectionVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    oMovieUrl = [NSURL URLWithString:urlStr];
//                }else if(model.subsectionVideoUrl.length) {
//                    movieUrl = [NSURL URLWithString:model.subsectionVideoUrl];
                }else if (model.subsectionRecorderVideoUrl.length) {
                    movieUrl = [NSURL URLWithString:model.subsectionRecorderVideoUrl];
                    oMovieUrl = [NSURL URLWithString:model.subsectionVideoUrl];
                }
                break;
            }
        }
        if (!movieUrl) {
            break;
        }else {
            _movieUrl = movieUrl;
            [fileURLArray addObject:movieUrl];
            [oFileURLArray addObject:oMovieUrl];
            AVAsset *asset = [AVAsset assetWithURL:movieUrl];
            [vedioAssets addObject:asset];
        }
    }
    if (vedioAssets.count<=1) {
        complete(_movieUrl);
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        
        CGSize renderSize = CGSizeMake(0, 0);
        
        NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
        
        AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
        
        CMTime totalDuration = kCMTimeZero;
        
        //先去assetTrack 也为了取renderSize
        NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
        NSMutableArray *assetArray = [[NSMutableArray alloc] init];
        NSMutableArray *oAssetArray = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<fileURLArray.count;i++) {
            NSURL *fileURL = fileURLArray[i];
            NSURL *oFileURL = oFileURLArray[i];
            AVAsset *asset = [AVAsset assetWithURL:fileURL];
            AVAsset *oAsset = [AVAsset assetWithURL:oFileURL];
            
            if (!asset) {
                continue;
            }
            
            [assetArray addObject:asset];
            [oAssetArray addObject:oAsset];
            AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            [assetTrackArray addObject:assetTrack];
            
            renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
            renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
        }
        
        CGFloat renderW = MIN(renderSize.width, renderSize.height);
        
        for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {
            
            AVAsset *asset = [assetArray objectAtIndex:i];
            AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
            AVAsset *oAsset = [oAssetArray objectAtIndex:i];

            AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:[[oAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                 atTime:totalDuration
                                  error:nil];
            
            AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            
            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetTrack
                                 atTime:totalDuration
                                  error:&error];
            
            //fix orientationissue
            AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            
            totalDuration = CMTimeAdd(totalDuration, asset.duration);
            
            CGFloat rate;
            rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
            
            CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
            layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影响
            layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
            
            [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
            [layerInstruciton setOpacity:0.0 atTime:totalDuration];
            
            //data
            [layerInstructionArray addObject:layerInstruciton];
        }
        
        //get save path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                                 [NSString stringWithFormat:@"mergeVideo-%ld.mov",[[[NSUserDefaults standardUserDefaults] objectForKey:@"MOVIE_COUNT"] integerValue]+1]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", [[[NSUserDefaults standardUserDefaults] objectForKey:@"MOVIE_COUNT"] integerValue]+1] forKey:@"MOVIE_COUNT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        //export
        AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
        mainInstruciton.layerInstructions = layerInstructionArray;
        AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
        mainCompositionInst.instructions = @[mainInstruciton];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        mainCompositionInst.renderSize = CGSizeMake(renderW, renderW);
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
        exporter.videoComposition = mainCompositionInst;
        exporter.outputURL = url;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(exporter.outputURL);
                [self exportDidFinish:exporter];
            });
        }];
    });
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
