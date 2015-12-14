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

@interface YWMovieViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation YWMovieViewController
{
    UIView      *_tooBar;
    UIView      *_movie1;
    UIView      *_movie2;
    UICollectionView   *_collectionView;
    NSMutableArray     *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = @"模板名称";
    _dataSource = [[NSMutableArray alloc] init];
    [self createBackLeftItem];
    [self createSubViews];
    [self dataSource];
}

- (void)dataSource {
    for (NSInteger i=0; i<10; i++) {
        [_dataSource addObject:@""];
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
    
    _movie1 = [[UIView alloc] init];
    _movie1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_movie1];
    [_movie1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.top.offset(64);
        make.height.offset((kScreenHeight-((kScreenWidth-30)/5*2+10+64+49+10+10))/2);
    }];
    
    _movie2 = [[UIView alloc] init];
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

#pragma mark - action
- (void)actionBack:(UIButton *)button {
    AppDelegate *application = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [application movieVCToBack];
}

- (void)actionTakePhoto:(UIButton *)button {
    YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YWTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.textFont = [UIFont systemFontOfSize:12];
    cell.viewAlpha = 0.3;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
