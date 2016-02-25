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
//    UIActivityIndicatorView     *_activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"存入草稿箱" style:UIBarButtonItemStyleDone target:self action:@selector(actionRightItem)];
    _httpManager = [YWHttpManager shareInstance];
    _buttons = [[NSMutableArray alloc] init];
    _state = 2;
    
    [self createSubViews];
//    
//    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _activity.frame = self.view.bounds;
//    [self.view addSubview:_activity];
}

- (void)createSubViews {
    UIButton *releaseButton = [[UIButton alloc] init];
    releaseButton.backgroundColor = RGBColor(30, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    releaseButton.layer.masksToBounds = YES;
    releaseButton.layer.cornerRadius = 5;
    [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(actionRelease:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseButton];
    [releaseButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.bottom.right.offset(-20);
        make.height.offset(40);
    }];
    
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.backgroundColor = Subject_color;
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
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
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
    if (_recorderState) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self mergeAndSaveComplete:^(id responseObject) {
//                [_activity stopAnimating];
//                [SVProgressHUD showSuccessWithStatus:@"合成成功"];
                
                return responseObject;
            }];
        });
    }
    return nil;
}

/*
//合并
- (void)mergeAndSaveComplete:(NSURL * (^) (id responseObject))complete {
    //    [_activity startAnimating];
    //    [SVProgressHUD showWithStatus:@"合成中"];
    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // 2 - Video track
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAsset *lastAsset;
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction;
    AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction;
    for (NSInteger i=0; i<_template.templateSubsectionVideos.count; i++) {
        NSURL *url;
        for (YWSubsectionVideoModel *model in _template.templateSubsectionVideos) {
            if (model.subsectionVideoSort.integerValue == 1) {
                if (model.recorderVideoUrl) {
                    url = model.recorderVideoUrl;
                }else {
                    url = [NSURL URLWithString:model.subsectionVideoUrl];
                }
                break;
            }
        }
        AVAsset *medioAsset = [AVAsset assetWithURL:url];
        if (!i) {
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, medioAsset.duration) ofTrack:[[medioAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            //FIXING ORIENTATION//
            FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
            AVAssetTrack *FirstAssetTrack = [[medioAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
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
                [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
            }else{
                CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
                [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
            }
            [FirstlayerInstruction setOpacity:0.0 atTime:medioAsset.duration];
        }else {
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, medioAsset.duration) ofTrack:[[medioAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:lastAsset.duration error:nil];
            MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(lastAsset.duration, medioAsset.duration));
            SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
            AVAssetTrack *SecondAssetTrack = [[medioAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            UIImageOrientation SecondAssetOrientation_  = UIImageOrientationUp;
            BOOL  isSecondAssetPortrait_  = NO;
            CGAffineTransform secondTransform = SecondAssetTrack.preferredTransform;
            if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {SecondAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
            if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {SecondAssetOrientation_ =  UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
            if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {SecondAssetOrientation_ =  UIImageOrientationUp;}
            if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {SecondAssetOrientation_ = UIImageOrientationDown;}
            CGFloat SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.width;
            if(isSecondAssetPortrait_){
                SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.height;
                CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
                [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:lastAsset.duration];
            }else{
                ;
                CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
                [SecondlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:lastAsset.duration];
            }
            
            MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];;
            
            AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
            MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
            MainCompositionInst.frameDuration = CMTimeMake(1, 30);
            MainCompositionInst.renderSize = self.view.bounds.size;
        }
        lastAsset = medioAsset;
    }
    
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
    //    NSURL *outputURL;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(exporter.outputURL);
            [self exportDidFinish:exporter];
        });
    }];
}
*/

//合并
- (void)mergeAndSaveComplete:(NSURL * (^) (id responseObject))complete {
//    [_activity startAnimating];
//    [SVProgressHUD showWithStatus:@"合成中"];
    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // 2 - Video track
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAsset *lastAsset;
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction;
    AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction;
    for (NSInteger i=0; i<_template.templateSubsectionVideos.count; i++) {
        NSURL *url;
        for (YWSubsectionVideoModel *model in _template.templateSubsectionVideos) {
            if (model.subsectionVideoSort.integerValue == 1) {
                if (model.recorderVideoUrl) {
                    url = model.recorderVideoUrl;
                }else {
                    url = [NSURL URLWithString:model.subsectionVideoUrl];
                }
                break;
            }
        }
        AVAsset *medioAsset = [AVAsset assetWithURL:url];
        if (!i) {
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, medioAsset.duration) ofTrack:[[medioAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            //FIXING ORIENTATION//
            FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
            AVAssetTrack *FirstAssetTrack = [[medioAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
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
                [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
            }else{
                CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
                [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
            }
            [FirstlayerInstruction setOpacity:0.0 atTime:medioAsset.duration];
        }else {
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, medioAsset.duration) ofTrack:[[medioAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:lastAsset.duration error:nil];
            MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(lastAsset.duration, medioAsset.duration));
            SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
            AVAssetTrack *SecondAssetTrack = [[medioAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            UIImageOrientation SecondAssetOrientation_  = UIImageOrientationUp;
            BOOL  isSecondAssetPortrait_  = NO;
            CGAffineTransform secondTransform = SecondAssetTrack.preferredTransform;
            if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {SecondAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
            if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {SecondAssetOrientation_ =  UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
            if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {SecondAssetOrientation_ =  UIImageOrientationUp;}
            if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {SecondAssetOrientation_ = UIImageOrientationDown;}
            CGFloat SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.width;
            if(isSecondAssetPortrait_){
                SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.height;
                CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
                [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:lastAsset.duration];
            }else{
                ;
                CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
                [SecondlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:lastAsset.duration];
            }
            
            MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];;
            
            AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
            MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
            MainCompositionInst.frameDuration = CMTimeMake(1, 30);
            MainCompositionInst.renderSize = self.view.bounds.size;
        }
        lastAsset = medioAsset;
    }
    
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
//    NSURL *outputURL;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
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
    _state = [_buttons indexOfObject:button];
}

#pragma mark - request
- (void)requestSaveTrends {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"trendsId": _trends?_trends.trendsId:@"", @"type": @(_type), @"flag": _recorderState?@(1):@(2), @"state": @(_state), @"movieContent": _contentTextView.text, @"templateId": _template.templateId};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_httpManager requestWriteTrends:parameters coverImage:_image recorderMovies:_template.templateSubsectionVideos movieUrl:[self movieMerge] success:^(id responseObject) {
            [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } otherFailure:^(id responseObject) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        } failure:^(NSError *error) {
            
        }];
    });
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        _placeholderLabel.text = @"";
    }else {
        _placeholderLabel.text = @"写点什么吧...";
    }
}

@end
