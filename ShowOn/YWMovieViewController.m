//
//  YWMovieViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWMovieViewController.h"
#import "AppDelegate.h"
#import "YWTranscribeViewController.h"
#import "YWTemplateCollectionViewCell.h"
#import "YWMoviePlayView.h"
#import "YWHotView.h"
#import "YWCustomTabBarViewController.h"
#import "YWHotItemViewController.h"
#import "YWTemplateViewController.h"
#import "YWTemplateListViewController.h"

#import "YWMovieTemplateModel.h"

@interface YWMovieViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YWHotViewDelegate>

@end

@implementation YWMovieViewController
{
    UIView             *_tooBar;
    YWMoviePlayView    *_movie1;
    YWMoviePlayView    *_movie2;
    UICollectionView   *_collectionView;
    NSMutableArray     *_dataSource;
    YWHotView           *_hotView;
    BOOL             _isPushHotItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = @"模板名称";
    _dataSource = [[NSMutableArray alloc] init];
    [self createLeftItemWithTitle:@"首页"];
    [self createSubViews];
    [self dataSource];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenHotView) name:@"HiddenHotView" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HiddenHotView" object:nil];
}

- (void)hiddenHotView {
    self.navigationController.navigationBarHidden = NO;
    _hotView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isPushHotItem) {
        [self createHotView];
        _isPushHotItem = NO;
    }
}

- (void)actionLeftItem:(UIButton *)button {
    [self createHotView];
}

- (void)dataSource {
    for (NSInteger i=0; i<10; i++) {
        YWMovieTemplateModel *template = [[YWMovieTemplateModel alloc] init];
        template.templateId = @"1";
        template.templateTypeId = [NSString stringWithFormat:@"%u", arc4random()%3+1];
        template.templateName = [NSString stringWithFormat:@"名称%ld", (long)i];
        template.templateVideoCoverImage = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        
        [_dataSource addObject:template];
    }
    [_collectionView reloadData];
}

- (void)createSubViews {
    _tooBar = [[UIView alloc] init];
    _tooBar.backgroundColor = RGBColor(30, 30, 30);
    [self.view addSubview:_tooBar];
    [_tooBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(60);
    }];
    
    UIButton *takePhotoButton = [[UIButton alloc] init];
    takePhotoButton.backgroundColor = [UIColor redColor];
    takePhotoButton.layer.cornerRadius = 20;
    takePhotoButton.layer.masksToBounds = YES;
    [takePhotoButton addTarget:self action:@selector(actionTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_tooBar addSubview:takePhotoButton];
    [takePhotoButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tooBar.mas_centerY);
        make.centerX.equalTo(_tooBar.mas_centerX);
        make.height.offset(40);
        make.width.offset(40);
    }];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.backgroundColor = [UIColor redColor];
    backButton.layer.cornerRadius = 20;
    backButton.layer.masksToBounds = YES;
    [backButton addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    [_tooBar addSubview:backButton];
    [backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tooBar.mas_centerY);
        make.left.offset(20);
        make.height.offset(30);
        make.width.offset(50);
    }];
    
    _movie1 = [[YWMoviePlayView alloc] init];
    _movie1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_movie1];
    [_movie1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.top.offset(64);
        make.height.offset((kScreenHeight-((kScreenWidth-30)/5*2+10+64+49+10+10))/2);
    }];
    
    _movie2 = [[YWMoviePlayView alloc] init];
    _movie2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_movie2];
    [_movie2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.top.equalTo(_movie1.mas_bottom).offset(5);
        make.height.offset((kScreenHeight-((kScreenWidth-30)/5*2+10+64+49+10+10))/2);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-30)/5, (kScreenWidth-30)/5);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = Subject_color;
    [_collectionView registerClass:[YWTemplateCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.height.offset((kScreenWidth-30)/5*2+5);
        make.bottom.equalTo(takePhotoButton.mas_top).offset(-15);
    }];
}

- (void)createHotView {
    self.navigationController.navigationBarHidden = YES;
    if (_hotView) {
        _hotView.hidden = NO;
    }else {
        _hotView = [[YWHotView alloc] init];
        _hotView.delegate = self;
        [self.view addSubview:_hotView];
        [_hotView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
    }
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.itemSelectIndex = -1;
    tabBar.hiddenState = NO;
}

#pragma mark - action
- (void)actionBack:(UIButton *)button {
    [self createHotView];
}

- (void)actionTakePhoto:(UIButton *)button {
    YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YWHotViewDelegate
- (void)hotViewDidSelectItemWithIndex:(NSInteger)index {
    YWHotItemViewController *vc = [[YWHotItemViewController alloc] init];
    vc.template = _dataSource[index];
    [self.navigationController pushViewController:vc animated:YES];
    _isPushHotItem = YES;
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = YES;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YWTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.textFont = [UIFont systemFontOfSize:12];
    cell.viewAlpha = 0.3;
    cell.template = _dataSource[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        YWTemplateViewController *vc = [[YWTemplateViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        YWTemplateListViewController *vc = [[YWTemplateListViewController alloc] init];
        vc.template = _dataSource[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
