//
//  YWTranscribeViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTranscribeViewController.h"
#import "YWCustomSegView.h"
#import "YWMoviePlayView.h"
#import "YWMovieRecorder.h"
#import "YWEditCoverViewController.h"
#import "YWTemplateCollectionViewCell.h"
#import "YWSubsectionVideoModel.h"
#import "YWMovieTemplateModel.h"
#import "YWTrendsModel.h"
#import "YWMovieModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMoviePlayerViewController+Rotation.h"

@interface YWTranscribeViewController ()<YWCustomSegViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YWMoviePlayViewDelegate, YWMovieRecorderDelegate>

@end

@implementation YWTranscribeViewController
{
    UIScrollView        *_backgroundSV;
    YWCustomSegView     *_itemView;
    YWCustomSegView     *_modelItemView;
    YWMoviePlayView     *_playView;
    YWMovieRecorder     *_recorderView;
    NSMutableArray      *_collectionViews;
    NSMutableArray      *_labels;
    NSMutableArray      *_dataSource1;
    NSMutableArray      *_dataSource2;
    NSMutableArray      *_dataSource3;
    NSMutableArray      *_titles1;
    NSMutableArray      *_titles2;
    NSInteger            _collectionViewIndex;
    NSInteger            _cellIndex;
//    CGFloat              _recorderTime;
//    NSTimer             *_timer;
//    UIView              *_progressView;
//    NSMutableArray      *_recorderMovies;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _dataSource1 = [[NSMutableArray alloc] init];
    _dataSource2 = [[NSMutableArray alloc] init];
    _dataSource3 = [[NSMutableArray alloc] init];
//    _recorderMovies = [[NSMutableArray alloc] init];
    _titles1 = [[NSMutableArray alloc] initWithArray:@[@"近\n景", @"中\n景", @"远\n景"]];
    _titles2 = [[NSMutableArray alloc] initWithArray:@[@"特\n写", @"中\n景", @"远\n景"]];
    _collectionViews = [[NSMutableArray alloc] init];
    _labels = [[NSMutableArray alloc] init];
    _template = _trends?_trends.trendsMovie.movieTemplate:_template;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(run) userInfo:nil repeats:YES];
//    _timer.fireDate = [NSDate distantFuture];
    if (_trends) {
        for (YWSubsectionVideoModel *model in _template.templateSubsectionVideos) {
            model.subsectionVideoPerformanceStatus = @"2";
            if (model.subsectionRecorderVideoUrl.length) {
                model.subsectionVideoUrl = model.subsectionRecorderVideoUrl;
            }
        }
    }
    
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_recorderView startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_recorderView stopRunning];
}

- (void)createSubViews {
    _backgroundSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-40)];
    _backgroundSV.showsVerticalScrollIndicator = NO;
    _backgroundSV.bounces = NO;
    _backgroundSV.backgroundColor = RGBColor(50, 50, 50);
    [self.view addSubview:_backgroundSV];
    NSArray  *titles = @[@"取消", @"完成"];
    _itemView = [[YWCustomSegView alloc] initWithItemTitles:titles];
    _itemView.hiddenLineView = NO;
    _itemView.itemSelectIndex = 1;
    _itemView.hiddenBottomLineView = YES;
    _itemView.ywSelectTextColor = [UIColor orangeColor];
    _itemView.delegate = self;
    [self.view addSubview:_itemView];
    [_itemView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.offset(40);
    }];

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"video1.mov" ofType:nil];
    _playView = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 250) playUrl:@""];
    _playView.backgroundColor = Subject_color;
    _playView.layer.masksToBounds = YES;
//    _playView.isCountdown = YES;
    _playView.delegate = self;
    _playView.layer.cornerRadius = 5;
    _playView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
    _playView.layer.borderWidth = 1;
    [_backgroundSV addSubview:_playView];
//    [_playView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.offset(5);
//        make.width.offset(kScreenWidth-10);
//        make.height.offset(200);
//    }];
    
    UIButton *playButton = [[UIButton alloc] init];
    playButton.backgroundColor = Subject_color;
    [playButton setTitle:@"预览全片" forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:playButton];
    [playButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_playView.mas_right).offset(-5);
        make.height.offset(20);
        make.top.equalTo(_playView.mas_top).offset(5);
    }];

    _recorderView = [[YWMovieRecorder alloc] initWithFrame:CGRectMake(5, 260, kScreenWidth-10, 250)];
    _recorderView.backgroundColor = Subject_color;
    _recorderView.layer.masksToBounds = YES;
    _recorderView.layer.cornerRadius = 5;
    _recorderView.delegate = self;
    _recorderView.layer.borderColor = RGBColor(30, 30, 30).CGColor;
    _recorderView.layer.borderWidth = 1;
    if (_template.templateSubsectionVideos.count) {
        _recorderView.model = _template.templateSubsectionVideos[0];
    }
    [_backgroundSV addSubview:_recorderView];
//    [_recorderView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(5);
//        make.width.offset(kScreenWidth-10);
//        make.top.equalTo(_playView.mas_bottom).offset(5);
//        make.height.offset(200);
//    }];
    
    UIButton *restartButton = [[UIButton alloc] init];
    restartButton.backgroundColor = Subject_color;
    [restartButton setTitle:@"重新拍摄" forState:UIControlStateNormal];
    [restartButton setImage:[UIImage imageNamed:@"red_point_button.png"] forState:UIControlStateNormal];
    [restartButton addTarget:self action:@selector(actionRestart:) forControlEvents:UIControlEventTouchUpInside];
    [_recorderView addSubview:restartButton];
    [restartButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_recorderView.mas_right).offset(-5);
        make.height.offset(20);
        make.top.equalTo(_recorderView.mas_top).offset(5);
    }];
    
    UIButton *changeButton = [[UIButton alloc] init];
    changeButton.backgroundColor = Subject_color;
    [changeButton setTitle:@"切换" forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"change_shot_button.png"] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(actionChange:) forControlEvents:UIControlEventTouchUpInside];
    [_recorderView addSubview:changeButton];
    [changeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_recorderView.mas_left).offset(5);
        make.height.offset(20);
        make.top.equalTo(_recorderView.mas_top).offset(5);
    }];

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
        make.top.equalTo(_recorderView.mas_bottom);
    }];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 530, kScreenWidth, 85*3+20)];
    [_backgroundSV addSubview:bgView];
    
    for (NSInteger i=0; i<3; i++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(110, 80);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 85*i, kScreenWidth-30, 80) collectionViewLayout:layout];
        collectionView.backgroundColor = RGBColor(30, 30, 30);
//        collectionView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
    _backgroundSV.contentSize = CGSizeMake(kScreenWidth, 540+85*3+10);
    [self customSegView:_modelItemView didSelectItemWithIndex:0];
//    
//    _progressView = [[UIView alloc] initWithFrame:CGRectMake(30, -10, 1, 105)];
//    _progressView.backgroundColor = [UIColor redColor];
//    [bgView addSubview:_progressView];
}

#pragma mark - action
- (void)actionBack:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionPlay:(UIButton *)button {
    NSString *urlStr = [!_trends?_template.templateVideoUrl:_trends.trendsMovie.movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [moviePlayerViewController rotateVideoViewWithDegrees:!_trends?0:90];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
}

- (void)actionRestart:(UIButton *)button {
    _recorderView.model.subsectionVideoPerformanceStatus = @"2";
    _recorderView.model.subsectionRecorderVideoUrl = nil;
//    [_recorderMovies removeObject:_recorderView.model];
    _playView.urlStr = _recorderView.model.subsectionVideoUrl;
    for (UICollectionView *collectionView in _collectionViews) {
        [collectionView reloadData];
    }
}

- (void)actionChange:(UIButton *)button {
    YWTemplateCollectionViewCell *cell = (YWTemplateCollectionViewCell *)[_collectionViews[_collectionViewIndex] cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_cellIndex inSection:0]];
    [cell startRecorderAnimationWithDuration:12];
    return;
//    if (_recorderView.model.subsectionVideoPerformanceStatus.integerValue != 0) {
        [_recorderView changeCamera];
//    }
}

#pragma mark - YWMoviePlayViewDelegate
- (void)moviePlayViewPlayWithState:(BOOL)playState {
//    if (_recorderView.model.subsectionVideoPerformanceStatus.integerValue != 1) {
//        if (playState) {
//            [_recorderView startRecorder];
//            self.view.userInteractionEnabled = NO;
//        }
//    }
}

- (void)moviePlayViewPlayDown:(YWMoviePlayView *)view {
//    [_recorderView startRecorder];
//    self.view.userInteractionEnabled = YES;
}

#pragma mark - YWMovieRecorderDelegate
- (void)movieRecorderDown:(YWMovieRecorder *)view {
    view.model.subsectionVideoPerformanceStatus = @"1";
    for (UICollectionView *collectionView in _collectionViews) {
        [collectionView reloadData];
    }
//    [_recorderMovies addObject:view.model];
}

- (void)movieRecorderBegin:(YWMovieRecorder *)view {
    self.view.userInteractionEnabled = NO;
    YWTemplateCollectionViewCell *cell = (YWTemplateCollectionViewCell *)[_collectionViews[_collectionViewIndex] cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_cellIndex inSection:0]];
    [cell startRecorderAnimationWithDuration:view.model.subsectionVideoTime.floatValue];

//    _recorderTime = view.model.subsectionVideoTime.floatValue;
//    [self timerStart];
}

//- (void)timerStart {
//    _timer.fireDate = [NSDate distantPast];
//}
//
//- (void)run {
//    static CGFloat cnt;
//    NSInteger step = 110/_recorderTime;
//    [self recorderProgressAnimationWithFloat:step];
//    if (cnt > _recorderTime) {
//        cnt = 0;
//        _timer.fireDate = [NSDate distantFuture];
//        [self recorderDown];
//    }
//    cnt += 0.1;
//}
//
//- (void)recorderProgressAnimationWithFloat:(CGFloat)progress {
//    CGRect frame = _progressView.frame;
//    frame.origin.x += progress;
//    _progressView.frame = frame;
//}

- (void)recorderDown {
    self.view.userInteractionEnabled = YES;
}

#pragma mark - YWCustomSegViewDelegate
- (void)customSegView:(YWCustomSegView *)view didSelectItemWithIndex:(NSInteger)index {
    if ([view isEqual:_itemView]) {
        if (index) {
            BOOL state = NO;
            for (NSInteger i=0; i<_template.templateSubsectionVideos.count; i++) {
                if ([_template.templateSubsectionVideos[i] recorderVideoUrl]) {
                    state = YES;
                    break;
                }
            }
            if (state) {
                YWEditCoverViewController *vc = [[YWEditCoverViewController alloc] init];
                vc.trends = _trends;
                vc.template = _template;
//                vc.recorderMovies = _recorderMovies;
                BOOL state = YES;
                for (YWSubsectionVideoModel *model in _template.templateSubsectionVideos) {
                    if (model.subsectionVideoPerformanceStatus.integerValue != 1) {
                        state = NO;
                        break;
                    }
                }
                vc.recorderState = state;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请先录制视频" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alter show];
            }
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
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
            _playView.urlStr = model.subsectionVideoUrl;
            //        _playView.urlStr = _template.templateVideoUrl;
            model.subsectionVideoPerformanceStatus = model.subsectionVideoPerformanceStatus.integerValue==1?@"1":@"0";
            _recorderView.model = model;
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
    _playView.urlStr = subsectionVideoModel.subsectionVideoUrl;
    subsectionVideoModel.subsectionVideoPerformanceStatus = subsectionVideoModel.subsectionVideoPerformanceStatus.integerValue==1?@"1":@"0";
    _recorderView.model = subsectionVideoModel;
    for (UICollectionView *cv in _collectionViews) {
        [cv reloadData];
    }
//    _progressView.frame = CGRectMake(cell.frame.origin.x+30, -cell.frame.origin.y+10, 1, 105);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
