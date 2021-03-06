//
//  YWEditCoverViewController.m
//  ShowOn
//
//  Created by David Yu on 25/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWEditCoverViewController.h"
#import "YWEditTrendsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YWMovieTemplateModel.h"
#import "YWSubsectionVideoModel.h"
#import "YWTools.h"
#import "YWCutImageViewController.h"
#import "YWMovieModel.h"
#import "YWHttpManager.h"
#import "YWUserModel.h"

@interface YWEditCoverViewController ()<UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, YWCutImageViewControllerDelegate>

@end

@implementation YWEditCoverViewController
{
    UIImageView         *_coverImageView;
    UISegmentedControl  *_seg;
    UIScrollView        *_coverImageSV;
    NSMutableArray      *_coverImages;
    UIView              *_cutView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _coverImages = [[NSMutableArray alloc] init];
    self.title = @"制作封面";
    [self createRightItemWithTitle:@"裁剪"];
    
    [self createSubViews];
    [self movieFrameImage];
}

- (void)createSubViews {
    UIButton *downButton = [[UIButton alloc] init];
    downButton.backgroundColor = RGBColor(30, 30, 30);
    downButton.titleLabel.font = [UIFont systemFontOfSize:14];
    downButton.layer.masksToBounds = YES;
    downButton.layer.cornerRadius = 5;
    [downButton setTitle:@"完成" forState:UIControlStateNormal];
    [downButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(actionDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
    [downButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.bottom.right.offset(-20);
        make.height.offset(40);
    }];
    
    _seg = [[UISegmentedControl alloc] initWithItems:@[@"截图海报", @"自拍海报"]];
    _seg.backgroundColor = RGBColor(30, 30, 30);
    [_seg addTarget:self action:@selector(actionValueChange) forControlEvents:UIControlEventValueChanged];
    _seg.selectedSegmentIndex = 0;
    _seg.tintColor = [UIColor orangeColor];
    [self.view addSubview:_seg];
    [_seg makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(34);
        make.width.offset(160);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.offset(64+10);
    }];
    
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.backgroundColor = RGBColor(30, 30, 30);
    _coverImageView.layer.masksToBounds = YES;
    _coverImageView.layer.cornerRadius = 5;
    _coverImageView.image = nil;
    _coverImageView.clipsToBounds = YES;
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_coverImageView];
    [_coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_seg.mas_bottom).offset(20);
        make.height.width.offset(180*(kScreenWidth-40)/375.0);
    }];

    _coverImageSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 330, kScreenWidth, 100)];
    _coverImageSV.backgroundColor = RGBColor(30, 30, 30);
    _coverImageSV.delegate = self;
    _coverImageSV.bounces = NO;
    _coverImageSV.showsHorizontalScrollIndicator = NO;
    _coverImageSV.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_coverImageSV];
    
    _cutView = [[UIView alloc] initWithFrame:CGRectMake(20, 330, 80, 100)];
    _cutView.backgroundColor = [UIColor lightGrayColor];
    [_cutView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPan:)]];
    _cutView.alpha = 0.5;
    [self.view addSubview:_cutView];
}

#pragma mark - request
- (void)requestCommitCasting {
    [[YWHttpManager shareInstance] requestWriteCasting:@{@"userId": _user.userId} coverImage:_coverImageView.image movieUrl:_user.casting.movieRecorderUrl success:^(id responseObject) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
    } otherFailure:^(id responseObject) {
        [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (void)createScorllImagesWithImages:(NSArray *)images {
    _coverImageSV.contentSize = CGSizeMake(120*images.count, 100);
    for (NSInteger i=0; i<images.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(120*i, 10, 120, 80)];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        iv.backgroundColor = RGBColor(30, 30, 30);
        iv.image = images[i];
        [_coverImageSV addSubview:iv];
    }
}

- (void)obtainCutImage {
    CGRect rect = CGRectIntersection(_cutView.frame, _coverImageSV.frame);
    CGFloat x = fabs(_coverImageSV.contentOffset.x);
    CGFloat px = rect.origin.x + x;
    NSInteger i = px/120;
    UIImage *image = _coverImages[i];
    UIImage *cutImage = [YWTools cutImage:image withRect:CGRectMake((int)px%120, 0, 80, 80)];
    _coverImageView.image = cutImage;
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    [self obtainCutImage];
}

- (void)actionPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)actionDown:(UIButton *)button {
    if (_coverImageView.image) {
        if (_user) {
            [self requestCommitCasting];
        }else {
            YWEditTrendsViewController *vc = [[YWEditTrendsViewController alloc] init];
            vc.trends = _trends;
            vc.template = _template;
            //        vc.recorderMovies = _recorderMovies;
            vc.recorderState = _recorderState;
            vc.image = _coverImageView.image;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请选择封面" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alter show];
    }
}

- (void)actionValueChange {
    if (!_seg.selectedSegmentIndex) {
        _coverImageSV.hidden = NO;
    }else {
        [self takePhoto];
        _coverImageSV.hidden = YES;
    }
}

- (void)movieFrameImage {
    [_coverImages removeAllObjects];
    if (_user) {
        AVURLAsset *urlAsset=[AVURLAsset assetWithURL:_user.casting.movieRecorderUrl];
        for (NSInteger i=0; i<(int)CMTimeGetSeconds(urlAsset.duration); i++) {
            UIImage *image = [self thumbnailImageRequestUrl:_user.casting.movieRecorderUrl time:10*i];
            UIImage *rotationImage = [self fixOrientation:image];
            [_coverImages addObject:_isCasting?[self rotation:rotationImage]:rotationImage];
        }
    }else {
        for (YWSubsectionVideoModel *model in _template.templateSubsectionVideos) {
            if (model.recorderVideoUrl) {
                AVURLAsset *urlAsset=[AVURLAsset assetWithURL:model.recorderVideoUrl];
                for (NSInteger i=0; i<=urlAsset.duration.value/urlAsset.duration.timescale; i++) {
                    UIImage *image = [self thumbnailImageRequestUrl:model.recorderVideoUrl time:i];
                    UIImage *rotationImage = [self fixOrientation:image];
                    [_coverImages addObject:_isCasting?[self rotation:rotationImage]:rotationImage];
                }
            }
        }
    }
    [self createScorllImagesWithImages:_coverImages];
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

- (void)takePhoto {
    UIImagePickerController *albumPicker = [[UIImagePickerController alloc] init];
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear || UIImagePickerControllerCameraDeviceFront];
    if (!isCamera) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有可用摄像头"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    //拍照
    albumPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    albumPicker.delegate = self;
    [self presentViewController:albumPicker animated:YES completion:NULL];
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
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

#pragma mark - YWCutImageViewControllerDelegate
- (void)cutImageViewControllerCutImage:(UIImage *)cutImage {
    _coverImageView.image = cutImage;
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *im = [self fixOrientation:image];
    //关闭模态视图
    [picker dismissViewControllerAnimated:YES completion:NULL];
    YWCutImageViewController *cutVC = [[YWCutImageViewController alloc] init];
    cutVC.image = im;
    cutVC.delegate = self;
    [self.navigationController pushViewController:cutVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //关闭模态视图
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */
-(UIImage *)thumbnailImageRequestUrl:(NSURL *)url time:(CGFloat )timeBySecond{
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        DebugLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage

    CGImageRelease(cgImage);
    
    return image;
}


@end
