//
//  YWPreviewViewController.m
//  ShowOn
//
//  Created by David Yu on 16/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWPreviewViewController.h"
#import "YWCustomSegView.h"
#import "YWTemplateCollectionViewCell.h"
#import "YWSubsectionVideoModel.h"
#import "YWMovieTemplateModel.h"
#import "YWMovieModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YWPreviewViewController.h"
#import "YWMovieTemplateModel.h"
#import "MPMoviePlayerViewController+Rotation.h"

@interface YWPreviewViewController ()<YWCustomSegViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation YWPreviewViewController
{
    UIScrollView        *_backgroundSV;
    YWCustomSegView     *_modelItemView;
    NSMutableArray      *_collectionViews;
    NSMutableArray      *_labels;
    NSMutableArray      *_dataSource1;
    NSMutableArray      *_dataSource2;
    NSMutableArray      *_dataSource3;
    NSMutableArray      *_titles1;
    NSMutableArray      *_titles2;
    NSInteger            _collectionViewIndex;
    NSInteger            _cellIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = @"预览";
    _dataSource1 = [[NSMutableArray alloc] init];
    _dataSource2 = [[NSMutableArray alloc] init];
    _dataSource3 = [[NSMutableArray alloc] init];
    _titles1 = [[NSMutableArray alloc] initWithArray:@[@"近\n景", @"中\n景", @"远\n景"]];
    _titles2 = [[NSMutableArray alloc] initWithArray:@[@"特\n写", @"中\n景", @"远\n景"]];
    _collectionViews = [[NSMutableArray alloc] init];
    _labels = [[NSMutableArray alloc] init];

    [self createSubViews];
}

- (void)createSubViews {
    _backgroundSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
    _backgroundSV.showsVerticalScrollIndicator = NO;
    _backgroundSV.bounces = NO;
    _backgroundSV.backgroundColor = RGBColor(50, 50, 50);
    [self.view addSubview:_backgroundSV];

    NSArray  *modelTitles = @[@"顺序模式", @"景别模式"];
    _modelItemView = [[YWCustomSegView alloc] initWithItemTitles:modelTitles];
    _modelItemView.hiddenLineView = NO;
    _modelItemView.hiddenBottomLineView = YES;
    _modelItemView.ywSelectTextColor = [UIColor orangeColor];
    _modelItemView.delegate = self;
    [_backgroundSV addSubview:_modelItemView];
    [_modelItemView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.width.offset(kScreenWidth);
        make.height.offset(20);
        make.top.equalTo(_backgroundSV.mas_top);
    }];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 85*3+20)];
    [_backgroundSV addSubview:bgView];
    
    for (NSInteger i=0; i<3; i++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(110, 80);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 85*i, kScreenWidth-30, 80) collectionViewLayout:layout];
        collectionView.backgroundColor = RGBColor(30, 30, 30);
        [collectionView registerClass:[YWTemplateCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [bgView addSubview:collectionView];
        [_collectionViews addObject:collectionView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 85*i, 30, 80)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = _titles1[i];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        [_labels addObject:label];
    }
    [self customSegView:_modelItemView didSelectItemWithIndex:0];
}

#pragma mark - action
- (void)actionPlay:(YWSubsectionVideoModel *)model {
    NSURL *url;
    if (model.recorderVideoUrl) {
        url = model.recorderVideoUrl;
    }else {
        NSString *urlStr = [model.subsectionRecorderVideoUrl?:model.subsectionVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:urlStr];
    }
    MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    NSInteger rotation = !(model.subsectionRecorderVideoUrl || model.recorderVideoUrl)?90:0;
    [moviePlayerViewController rotateVideoViewWithDegrees:rotation];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
}

#pragma mark - YWCustomSegViewDelegate
- (void)customSegView:(YWCustomSegView *)view didSelectItemWithIndex:(NSInteger)index {
    [_dataSource1 removeAllObjects];
    [_dataSource2 removeAllObjects];
    [_dataSource3 removeAllObjects];
    for (YWSubsectionVideoModel *model in _template.templateSubsectionVideos) {
        //分段视频类型（ 1、顺序模式(3、近景,4、中景,5、远景,),2、景别模式(6、特写,7、中景,8、远景)）
        model.subsectionVideoPerformanceStatus = (model.subsectionVideoPerformanceStatus.integerValue==1)?@"1":@"2";
        if (model.subsectionVideoType.integerValue == 3*(index+1)) {
            [_dataSource1 addObject:model];
        }else if (model.subsectionVideoType.integerValue == 3*(index+1)+1) {
            [_dataSource2 addObject:model];
        }else if (model.subsectionVideoType.integerValue == 3*(index+1)+2) {
            [_dataSource3 addObject:model];
        }
    }
    YWSubsectionVideoModel *model;
    if (_dataSource1.count) {
        model = _dataSource1[0];
    }else if (_dataSource2.count) {
        model = _dataSource2[0];
    }else if (_dataSource3.count) {
        model = _dataSource3[0];
    }
    if (model) {
        _collectionViewIndex = 0;
        _cellIndex = 0;
    }
    for (NSInteger i=0; i<3; i++) {
        UILabel *label = _labels[i];
        label.text = !index?_titles1[i]:_titles2[i];
        UICollectionView *collectionView = _collectionViews[i];
        [collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch ([_collectionViews indexOfObject:collectionView]) {
        case 0:
            return _dataSource1.count;
            break;
        case 1:
            return _dataSource2.count;
            break;
        case 2:
            return _dataSource3.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YWTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
//    cell.delegate = self;
    cell.isPlay = YES;
    cell.textFont = [UIFont systemFontOfSize:12];
    cell.viewAlpha = 0.3;
    NSArray *array = @[_dataSource1, _dataSource2, _dataSource3];
    cell.subsectionVideo = array[[_collectionViews indexOfObject:collectionView]][indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cIndex = [_collectionViews indexOfObject:collectionView];
    _collectionViewIndex = cIndex;
    _cellIndex = indexPath.row;
    NSArray *array = @[_dataSource1, _dataSource2, _dataSource3];
    for (NSArray *arr in array) {
        for (YWSubsectionVideoModel *model in arr) {
            if (model.subsectionVideoPerformanceStatus.integerValue == 0) {
                model.subsectionVideoPerformanceStatus = @"2";
            }
        }
    }
    YWSubsectionVideoModel *subsectionVideoModel = array[cIndex][indexPath.row];
//    if (subsectionVideoModel.recorderVideoUrl) {
//        _playView.url = subsectionVideoModel.recorderVideoUrl;
//    }else {
//        _playView.urlStr = subsectionVideoModel.subsectionRecorderVideoUrl?:subsectionVideoModel.subsectionVideoUrl;
//    }
//    subsectionVideoModel.subsectionVideoPerformanceStatus = subsectionVideoModel.subsectionVideoPerformanceStatus.integerValue==1?@"1":@"0";
//    for (UICollectionView *cv in _collectionViews) {
//        [cv reloadData];
//    }
    [self actionPlay:subsectionVideoModel];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
