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

@interface YWTranscribeViewController ()<YWCustomSegViewDelegate>

@end

@implementation YWTranscribeViewController
{
    UIScrollView        *_backgroundSV;
    YWCustomSegView     *_itemView;
    YWCustomSegView     *_modelItemView;
    YWMoviePlayView     *_playView;
    YWMovieRecorder     *_recorderView;
    UIView              *_orderModelBackgroundView;
    UIView              *_shootScaleModelBackgroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    
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

- (void)createSubViews {
    _backgroundSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
    _backgroundSV.backgroundColor = Subject_color;
    [self.view addSubview:_backgroundSV];
    NSArray  *titles = @[@"取消", @"完成"];
    _itemView = [[YWCustomSegView alloc] initWithItemTitles:titles];
    _itemView.hiddenLineView = NO;
    _itemView.ywSelectTextColor = [UIColor orangeColor];
    _itemView.delegate = self;
    [self.view addSubview:_itemView];
    [_itemView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.offset(40);
    }];

    _playView = [[YWMoviePlayView alloc] init];
    _playView.backgroundColor = [UIColor greenColor];
    [_backgroundSV addSubview:_playView];
    [_playView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(200);
    }];
    
    _recorderView = [[YWMovieRecorder alloc] init];
    _recorderView.backgroundColor = [UIColor greenColor];
    [_backgroundSV addSubview:_recorderView];
    [_recorderView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(_playView.mas_bottom);
        make.height.offset(200);
    }];
    
    NSArray  *modelTitles = @[@"顺序模式", @"景别模式"];
    _modelItemView = [[YWCustomSegView alloc] initWithItemTitles:modelTitles];
    _modelItemView.hiddenLineView = NO;
    _modelItemView.ywSelectTextColor = [UIColor orangeColor];
    _modelItemView.delegate = self;
    [_backgroundSV addSubview:_modelItemView];
    [_modelItemView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.offset(20);
        make.top.equalTo(_recorderView.mas_bottom);
    }];
    
    _orderModelBackgroundView = [[UIView alloc] init];
    _orderModelBackgroundView.backgroundColor = Subject_color;
    [_backgroundSV addSubview:_orderModelBackgroundView];
    [_orderModelBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(300);
        make.top.equalTo(_modelItemView.mas_bottom);
    }];
    
    _shootScaleModelBackgroundView = [[UIView alloc] init];
    _shootScaleModelBackgroundView.backgroundColor = Subject_color;
    _shootScaleModelBackgroundView.hidden = YES;
    [_backgroundSV addSubview:_shootScaleModelBackgroundView];
    [_shootScaleModelBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(300);
        make.top.equalTo(_modelItemView.mas_bottom);
    }];

//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake((kScreenWidth-30)/5, (kScreenWidth-30)/5);
//    
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    _collectionView.backgroundColor = Subject_color;
//    [_collectionView registerClass:[YWTemplateCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
//    _collectionView.delegate = self;
//    _collectionView.dataSource = self;
//    [self.view addSubview:_collectionView];
//    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(5);
//        make.right.offset(-5);
//        make.height.offset((kScreenWidth-30)/5*2+5);
//        make.bottom.equalTo(takePhotoButton.mas_top).offset(-15);
//    }];

}

#pragma mark - action
- (void)actionBack:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - YWCustomSegViewDelegate
- (void)customSegView:(YWCustomSegView *)view didSelectItemWithIndex:(NSInteger)index {
    if ([view isEqual:_itemView]) {
        if (index) {
            YWEditCoverViewController *vc = [[YWEditCoverViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
    
    }
}




@end
