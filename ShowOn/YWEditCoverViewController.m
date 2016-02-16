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

@interface YWEditCoverViewController ()<UIScrollViewDelegate>

@end

@implementation YWEditCoverViewController
{
    UIImageView         *_coverImageView;
    UISegmentedControl  *_seg;
    UIScrollView        *_coverImageSV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = @"制作封面";
    
    [self createSubViews];
}

- (void)createSubViews {
    UIButton *downButton = [[UIButton alloc] init];
    downButton.backgroundColor = RGBColor(30, 30, 30);
    downButton.titleLabel.font = [UIFont systemFontOfSize:14];
    downButton.layer.masksToBounds = YES;
    downButton.layer.cornerRadius = 5;
    [downButton setTitle:@"完成" forState:UIControlStateNormal];
    [downButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
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
    [self.view addSubview:_coverImageView];
    [_coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.top.equalTo(_seg.mas_bottom).offset(20);
        make.height.offset(180);
    }];

    _coverImageSV = [[UIScrollView alloc] init];
    _coverImageSV.backgroundColor = Subject_color;
    _coverImageSV.delegate = self;
    [self.view addSubview:_coverImageSV];
    [_coverImageSV makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(100);
        make.top.equalTo(_coverImageView.mas_bottom).offset(30);
    }];
}

#pragma mark - action
- (void)actionDown:(UIButton *)button {
    YWEditTrendsViewController *vc = [[YWEditTrendsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionValueChange {

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */
-(UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond{
    //创建URL
    NSURL *url=[NSURL URLWithString:@""];
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


@end
