//
//  YWEdithTrendsViewController.m
//  ShowOn
//
//  Created by David Yu on 25/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWEditTrendsViewController.h"
#import "YWHttpManager.h"
#import "YWDataBaseManager.h"
#import "YWUserModel.h"
#import "YWTrendsModel.h"
#import <AVFoundation/AVFoundation.h>
#import "YWSubsectionVideoModel.h"
#import "YWMovieTemplateModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YWMovieModel.h"

@interface YWEditTrendsViewController ()<UITextViewDelegate>

@end

@implementation YWEditTrendsViewController
{
    UIImageView    *_coverImageView;
    UILabel        *_templateNameLabel;
    UITextView     *_contentTextView;
    UILabel        *_placeholderLabel;
    YWHttpManager  *_httpManager;
    NSInteger       _type;      //合演，仅自己可见
    NSInteger       _state;     //2.发布，1.草稿
    NSMutableArray *_buttons;
//    NSInteger       _flag;      //是否是完整视频（1：完整  2：分段）
    UIActivityIndicatorView     *_activity;
    NSURL          *_movieUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"存入草稿箱" style:UIBarButtonItemStyleDone target:self action:@selector(actionRightItem)];
    _httpManager = [YWHttpManager shareInstance];
    _buttons = [[NSMutableArray alloc] init];
    _state = 1;
    
    [self createSubViews];
    _movieUrl = [self movieMerge];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.frame = self.view.bounds;
    [self.view addSubview:_activity];
}

- (void)createSubViews {
    UIButton *releaseButton = [[UIButton alloc] init];
    releaseButton.backgroundColor = RGBColor(30, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    releaseButton.layer.masksToBounds = YES;
    releaseButton.layer.cornerRadius = 5;
    [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(actionRelease:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseButton];
    [releaseButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.bottom.right.offset(-20);
        make.height.offset(40);
    }];
    
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.backgroundColor = Subject_color;
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView.clipsToBounds = YES;
    _coverImageView.image = _image;
    [self.view addSubview:_coverImageView];
    [_coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(64);
        make.height.offset(200);
    }];
    
    _templateNameLabel = [[UILabel alloc] init];
    _templateNameLabel.backgroundColor = Subject_color;
    _templateNameLabel.font = [UIFont systemFontOfSize:14];
    _templateNameLabel.text = nil;
    [self.view addSubview:_templateNameLabel];
    [_templateNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(_coverImageView.mas_bottom);
    }];
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.backgroundColor = [UIColor whiteColor];
    _contentTextView.delegate = self;
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.layer.cornerRadius = 5;
    _contentTextView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_contentTextView];
    [_contentTextView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_templateNameLabel.mas_bottom);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(150);
    }];
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.font = [UIFont systemFontOfSize:14];
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.text = @"写点什么吧...";
    [self.view addSubview:_placeholderLabel];
    [_placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_templateNameLabel.mas_bottom).offset(5);
        make.left.offset(16);
        make.right.offset(-10);
        make.height.offset(20);
    }];
    
    NSArray *titles = @[@"发起合演", @"尽自己可见"];
    for (NSInteger i=0; i<2; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = Subject_color;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"choose_normal_small.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"choose_selected_small.png"] forState:UIControlStateSelected];
        [self.view addSubview:button];
        [_buttons addObject:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentTextView.mas_bottom);
            make.left.offset(100*i+20);
            make.height.offset(20);
            make.width.offset(120);
        }];
    }
}

#pragma mark - private
- (NSURL *)movieMerge {
//    if (_recorderState) {
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"合成中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self mergeAndSaveCompletes:^(id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"合成成功"];
                    self.view.userInteractionEnabled = YES;
                    _movieUrl = responseObject;
                });
                
                return responseObject;
            }];
        });
//    }
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
                    //                }else if(model.subsectionVideoUrl.length) {
                    //                    movieUrl = [NSURL URLWithString:model.subsectionVideoUrl];
                }else if (model.subsectionRecorderVideoUrl.length) {
                    movieUrl = [NSURL URLWithString:[model.subsectionRecorderVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    oMovieUrl = [NSURL URLWithString:[model.subsectionVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                }else if (model.subsectionVideoUrl.length) {
                    movieUrl = [NSURL URLWithString:[model.subsectionVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    oMovieUrl = [NSURL URLWithString:[model.subsectionVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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

////合并
//- (void)mergeAndSaveComplete:(NSURL * (^) (id responseObject))complete {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.view.userInteractionEnabled = NO;
//        [SVProgressHUD showWithStatus:@"合成中"];
//    });
//    NSMutableArray *vedioAssets = [NSMutableArray array];
//    NSMutableArray *audioAssets = [NSMutableArray array];
//    for (NSInteger i=0; i<_template.templateSubsectionVideos.count; i++) {
//        NSURL *movieUrl;
//        NSURL *audioUrl;
//        for (YWSubsectionVideoModel *model in _template.templateSubsectionVideos) {
//            if (model.subsectionAudioUrl.length) {
//                audioUrl = [NSURL URLWithString:model.subsectionAudioUrl];
//            }
//            if (model.subsectionVideoSort.integerValue == i+1) {
//                if (model.recorderVideoUrl) {
//                    movieUrl = model.recorderVideoUrl;
//                }else if(model.subsectionVideoUrl.length) {
//                    movieUrl = [NSURL URLWithString:model.subsectionVideoUrl];
//                }else if (model.subsectionRecorderVideoUrl.length) {
//                    movieUrl = [NSURL URLWithString:model.subsectionRecorderVideoUrl];
//                }
//                break;
//            }
//        }
//        if (audioUrl) {
//            AVAsset *asset = [AVAsset assetWithURL:movieUrl];
//            [audioAssets addObject:asset];
//        }
//        if (!movieUrl) {
//            break;
//        }else {
//            _movieUrl = movieUrl;
//            AVAsset *asset = [AVAsset assetWithURL:movieUrl];
//            [vedioAssets addObject:asset];
//        }
//    }
//    if (vedioAssets.count<=1) {
//        return;
//    }
//    //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
//    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
//    
//    //VIDEO TRACK
//    AVAsset *firstAsset = vedioAssets.firstObject;
//    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//    //AUDIO TRACK
//    if(audioAssets.count){
//        AVAsset *audioAsset = audioAssets.firstObject;
//        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//        [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//    }
//    
//    //FIXING ORIENTATION//
//    AVMutableVideoCompositionLayerInstruction *firstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
//    AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
//    BOOL  isFirstAssetPortrait_  = NO;
//    CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
//    if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)  {FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;}
//    if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)  {FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;}
//    if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {FirstAssetOrientation_ =  UIImageOrientationUp;}
//    if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {FirstAssetOrientation_ = UIImageOrientationDown;}
//    CGFloat FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.width;
//    if(isFirstAssetPortrait_){
//        FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.height;
//        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
//        [firstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
//    }else{
//        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
//        [firstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
//    }
//    [firstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
//    
//    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    NSMutableArray *othernextLayerInstructions = [NSMutableArray arrayWithObjects:firstlayerInstruction, nil];
//    CMTime time = CMTimeAdd(kCMTimeZero, firstAsset.duration);
//    for (NSInteger i=1; i<vedioAssets.count; i++) {
//        AVAsset *nextAsset = vedioAssets[i];
//        AVMutableCompositionTrack *nextTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
//        [nextTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, nextAsset.duration) ofTrack:[[nextAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:time error:nil];
//        //AUDIO TRACK
//        if(audioAssets.count>i){
//            AVAsset *audioAsset = audioAssets[i];
//            AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//            [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:time error:nil];
//        }
//        time = CMTimeAdd(time, nextAsset.duration);
//        //FIXING ORIENTATION//
//        AVMutableVideoCompositionLayerInstruction *nextLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:nextTrack];
//        AVAssetTrack *nextAssetTrack = [[nextAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//        UIImageOrientation nextAssetOrientation_  = UIImageOrientationUp;
//        BOOL  isSecondAssetPortrait_  = NO;
//        CGAffineTransform secondTransform = nextAssetTrack.preferredTransform;
//        if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {nextAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
//        if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {nextAssetOrientation_ =  UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
//        if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {nextAssetOrientation_ =  UIImageOrientationUp;}
//        if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {nextAssetOrientation_ = UIImageOrientationDown;}
//        CGFloat SecondAssetScaleToFitRatio = 320.0/nextAssetTrack.naturalSize.width;
//        if(isSecondAssetPortrait_){
//            SecondAssetScaleToFitRatio = 320.0/nextAssetTrack.naturalSize.height;
//            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
//            [nextLayerInstruction setTransform:CGAffineTransformConcat(nextAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:firstAsset.duration];
//        }else{
//            ;
//            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
//            [nextLayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(nextAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:firstAsset.duration];
//        }
//        [othernextLayerInstructions addObject:nextLayerInstruction];
//    }
//    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, time);
//    
//    MainInstruction.layerInstructions = [NSArray arrayWithArray:othernextLayerInstructions];
//    
//    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
//    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
//    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
//    MainCompositionInst.renderSize = CGSizeMake(320.0, 480.0);
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
//                             [NSString stringWithFormat:@"mergeVideo-%ld.mov",[[[NSUserDefaults standardUserDefaults] objectForKey:@"MOVIE_COUNT"] integerValue]+1]];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", [[[NSUserDefaults standardUserDefaults] objectForKey:@"MOVIE_COUNT"] integerValue]+1] forKey:@"MOVIE_COUNT"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
//    
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
//    exporter.outputURL=url;
//    exporter.outputFileType = AVFileTypeQuickTimeMovie;
//    exporter.videoComposition = MainCompositionInst;
//    exporter.shouldOptimizeForNetworkUse = YES;
//    [exporter exportAsynchronouslyWithCompletionHandler:^
//     {
//         dispatch_async(dispatch_get_main_queue(), ^{
//             complete(exporter.outputURL);
//             [self exportDidFinish:exporter];
//         });
//     }];
//}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (error) {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
//                    } else {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
//                    }
//                });
            }];
        }
    }
}

#pragma mark - action
- (void)actionRightItem {
    _type = 1;
    [self requestSaveTrends];
}

- (void)actionRelease:(UIButton *)button {
    _type = 2;
    [self requestSaveTrends];
}

- (void)actionOnClick:(UIButton *)button {
    button.selected = YES;
    UIButton *btn = _buttons[[_buttons indexOfObject:button]?0:1];
    btn.selected = NO;
    _state = [_buttons indexOfObject:button]*2+2;
}

#pragma mark - request
- (void)requestSaveTrends {
    if (_trends) {
        _state = 2;
    }
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"trendsId": _trends?_trends.trendsId:@"", @"state": @(_type), @"templateId": _template?_template.templateId:_trends.trendsMovie.movieTemplate.templateId, @"flag": _recorderState?@(1):@(2), @"type": @(_state), @"movieContent": _contentTextView.text, @"templateId": _template.templateId};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_httpManager requestWriteTrends:parameters coverImage:_image recorderMovies:_template.templateSubsectionVideos movieUrl:_movieUrl success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } otherFailure:^(id responseObject) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD showWithStatus:@"上传中，请稍等。。。"];
        });
    });
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        _placeholderLabel.text = @"";
    }else {
        _placeholderLabel.text = @"写点什么吧...";
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_contentTextView resignFirstResponder];
}

@end
