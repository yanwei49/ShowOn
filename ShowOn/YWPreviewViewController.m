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
    MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:_movieUrl];
    [moviePlayerViewController rotateVideoViewWithDegrees:90];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
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
        [self mergeAndSaveComplete:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"合成成功"];
                self.view.userInteractionEnabled = YES;
                _movieUrl = responseObject;
                _coverImageView.image = [self rotation:[YWTools thumbnailImageRequestUrl:_movieUrl time:0]];
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
                }else if(model.subsectionVideoUrl.length) {
                    movieUrl = [NSURL URLWithString:model.subsectionVideoUrl];
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
    if(audioAssets.count){
        AVAsset *audioAsset = audioAssets.firstObject;
        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }
    
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
        if(audioAssets.count>i){
            AVAsset *audioAsset = audioAssets[i];
            AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:time error:nil];
        }
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
