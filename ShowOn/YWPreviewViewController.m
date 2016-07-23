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
    NSURL               *_fRecordermovieUrl;
    UIImageView         *_coverImageView;
    UIButton            *_playButton;
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

    _playButton = [[UIButton alloc] init];
    [_playButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    [_playButton makeConstraints:^(MASConstraintMaker *make) {
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
    [SVProgressHUD showWithStatus:@"合成中..."];
    self.view.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self mergeAndSaveCompletes:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"合成成功"];
                _playButton.userInteractionEnabled = YES;
                self.view.userInteractionEnabled = YES;
                _movieUrl = responseObject;
                _coverImageView.image = [YWTools thumbnailImageRequestUrl:_fRecordermovieUrl time:0];
            });
            
            return responseObject;
        }];
    });
    return nil;
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
                }else if (model.subsectionRecorderVideoUrl.length) {
                    movieUrl = [NSURL URLWithString:model.subsectionRecorderVideoUrl];
                    oMovieUrl = [NSURL URLWithString:[model.subsectionVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                }else if (model.subsectionVideoUrl.length) {
                    movieUrl = [NSURL URLWithString:[model.subsectionVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    oMovieUrl = [NSURL URLWithString:[model.subsectionVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                }
                if (!i) {
                    _fRecordermovieUrl = movieUrl;
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
