//
//  YWOtherMovieViewController.m
//  ShowOn
//
//  Created by David Yu on 18/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWOtherMovieViewController.h"
#import "YWMovieCallingCardCollectionViewCell.h"
#import "YWDataBaseManager.h"
#import "YWParser.h"
#import "YWHttpManager.h"
#import "YWUserModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMoviePlayerViewController+Rotation.h"
#import "YWTrendsModel.h"
#import "YWMovieModel.h"

@interface YWOtherMovieViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@end

@implementation YWOtherMovieViewController
{
    NSMutableArray                  *_dataSource;
    UICollectionView                *_collectionView;
    YWHttpManager                   *_httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = @"个人视频";
    _httpManager = [YWHttpManager shareInstance];
    _dataSource = [[NSMutableArray alloc] init];
    
    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestMovieList];
}

- (void)createSubViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-5)/2, 200);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = Subject_color;
    [_collectionView registerClass:[YWMovieCallingCardCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - request
- (void)requestMovieList {
    NSDictionary *parameters = @{@"userId": _user.userId};
    [_httpManager requestMovieList:parameters success:^(id responseObject) {
        [_dataSource removeAllObjects];
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser trendsWithArray:responseObject[@"movieList"]];
        [_dataSource addObjectsFromArray:array];
        [_collectionView reloadData];
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YWMovieCallingCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.model = _dataSource[indexPath.row];
    cell.stateButtonHidden = YES;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self checkNewWorkIsWifi]) {
        YWTrendsModel *trends = _dataSource[indexPath.row];
        NSString *urlStr = [trends.trendsMovie.movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
//        [moviePlayerViewController rotateVideoViewWithDegrees:90];
        [self presentViewController:moviePlayerViewController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"你当前网络不是WiFi，是否播放" message:nil delegate:nil cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alter show];
        [alter clickedButtonAtIndex:^(NSInteger buttonIndex) {
            YWTrendsModel *trends = _dataSource[indexPath.row];
            NSString *urlStr = [trends.trendsMovie.movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlStr];
            MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
//            [moviePlayerViewController rotateVideoViewWithDegrees:90];
            [self presentViewController:moviePlayerViewController animated:YES completion:nil];
        }];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}



@end
