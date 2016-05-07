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
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWTrendsModel.h"
#import "YWMovieModel.h"
#import "YWMovieTemplateModel.h"
#import "YWDataBaseManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YWDataBaseManager.h"
#import "YWUserModel.h"
#import "MPMoviePlayerViewController+Rotation.h"

@interface YWMovieViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YWHotViewDelegate>

@end

@implementation YWMovieViewController
{
    UIView              *_tooBar;
    YWMoviePlayView     *_movie1;
    YWMoviePlayView     *_movie2;
    UICollectionView    *_collectionView;
    YWHotView           *_hotView;
    BOOL                 _isPushHotItem;
    YWHttpManager       *_httpManager;
    NSMutableArray      *_templateArray;
    NSInteger            _selectIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = @"模板名称";
    _templateArray = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _selectIndex = 1;
    [self createLeftItemWithTitle:@"首页"];
    [self createSubViews];
    [self requestTemplateList];
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
    _movie1.hidden = NO;
    [YWNoCotentView showNoCotentViewWithState:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isPushHotItem) {
        [self createHotView];
        _isPushHotItem = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_movie1 stop];
    [_movie2 stop];
}

#pragma mark - action
- (void)actionLeftItem:(UIButton *)button {
    [self createHotView];
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
    takePhotoButton.backgroundColor = RGBColor(30, 30, 30);
    [takePhotoButton setImage:[UIImage imageNamed:@"red_point.png"] forState:UIControlStateNormal];
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
    backButton.backgroundColor = RGBColor(30, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"back_orange.png"] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = 20;
    backButton.layer.masksToBounds = YES;
    [backButton addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    [_tooBar addSubview:backButton];
    [backButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_tooBar.mas_centerY);
        make.left.offset(20);
        make.height.offset(30);
        make.width.offset(30);
    }];
    
    _movie1 = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(5, 64, kScreenWidth-10, (kScreenHeight-((kScreenWidth-30)/5*2+10+64+49+10+10))/2) playUrl:@""];
    _movie1.backgroundColor = RGBColor(30, 30, 30);
    [self.view addSubview:_movie1];
//    [_movie1 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(5);
//        make.right.offset(-5);
//        make.top.offset(64);
//        make.height.offset((kScreenHeight-((kScreenWidth-30)/5*2+10+64+49+10+10))/2);
//    }];
    
    _movie2 = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(5, (kScreenHeight-((kScreenWidth-30)/5*2+10+64+49+10+10))/2+64+5, kScreenWidth-10, (kScreenHeight-((kScreenWidth-30)/5*2+10+64+49+10+10))/2) playUrl:@""];
    _movie2.backgroundColor = RGBColor(30, 30, 30);
    [self.view addSubview:_movie2];
//    [_movie2 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(5);
//        make.right.offset(-5);
//        make.top.equalTo(_movie1.mas_bottom).offset(5);
//        make.height.offset((kScreenHeight-((kScreenWidth-30)/5*2+10+64+49+10+10))/2);
//    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-30)/5, (kScreenWidth-30)/5);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = Subject_color;
    [_collectionView registerClass:[YWTemplateCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"moreItem"];
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
    _movie1.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    if (_hotView) {
        _hotView.hidden = NO;
    }else {
        _hotView = [[YWHotView alloc] init];
        _hotView.delegate = self;
        _hotView.dataSource = _templateArray;
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
    if ([[YWDataBaseManager shareInstance] loginUser]) {
        if (_selectIndex < _templateArray.count+1) {
            YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
            vc.template = _templateArray[_selectIndex-1];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        [self login];
    }
}

#pragma mark - request
- (void)requestTemplateList {
    [_httpManager requestTemplateList:nil success:^(id responseObject) {
        [_templateArray removeAllObjects];
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser templateWithArray:responseObject[@"templateList"]];
        [_templateArray addObjectsFromArray:array];
        if (_templateArray.count) {
            self.title = [_templateArray[0] templateName];
            _movie1.urlStr = [_templateArray[0] templateVideoUrl];
            if ([[_templateArray[0] templateTrends] count]) {
                _movie2.urlStr = [[[_templateArray[0] templateTrends][0] trendsMovie] movieUrl];
            }else {
                _movie2.urlStr = @"";
            }
        }
        _hotView.dataSource = _templateArray;
        [_collectionView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - YWHotViewDelegate
- (void)hotViewDidSelectItemWithTemplate:(YWMovieTemplateModel *)template {
    YWHotItemViewController *vc = [[YWHotItemViewController alloc] init];
    vc.template = template;
    [self.navigationController pushViewController:vc animated:YES];
    _isPushHotItem = YES;
    YWCustomTabBarViewController *tabBar = (YWCustomTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBar.hiddenState = YES;
}

- (void)hotViewDidSelectPlayItemWithTemplate:(YWMovieTemplateModel *)template {
    NSString *urlStr = [template.templateVideoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [moviePlayerViewController rotateVideoViewWithDegrees:0];
    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
    [self requestPlayModelId:template.templateId withType:1];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _templateArray.count+1<=10?_templateArray.count+1:10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreItem" forIndexPath:indexPath];
        UIImageView *img = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        img.image = [UIImage imageNamed:@"add_img.png"];
        [cell.contentView addSubview:img];
        
        return cell;
    }else {
        YWTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
        cell.textFont = [UIFont systemFontOfSize:12];
        cell.viewAlpha = 0.3;
        cell.template = _templateArray[indexPath.row-1];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        YWTemplateViewController *vc = [[YWTemplateViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        _selectIndex = indexPath.row;
        YWMovieTemplateModel *template = _templateArray[indexPath.row-1];
        self.title = template.templateName;
        _movie1.urlStr = template.templateVideoUrl?:@"";
        YWTrendsModel *trends = template.templateTrends.count?template.templateTrends[0]:nil;
        _movie2.urlStr = trends.trendsMovie.movieUrl?:@"";
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
