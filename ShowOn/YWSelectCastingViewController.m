//
//  YWSelectCastingViewController.m
//  ShowOn
//
//  Created by David Yu on 6/5/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWSelectCastingViewController.h"
#import "YWParser.h"
#import "YWHttpManager.h"
#import "YWUserModel.h"
#import "YWMovieCallingCardCollectionViewCell.h"
#import "YWDataBaseManager.h"
#import "YWReorderCastingViewController.h"

@interface YWSelectCastingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation YWSelectCastingViewController
{
    NSMutableArray                  *_dataSource;
    UICollectionView                *_collectionView;
    YWHttpManager                   *_httpManager;
    NSInteger                        _selectIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"casting模板";
    [self createRightItemWithTitle:@"录制"];
    _selectIndex = 0;
    
    [self createSubViews];
    [self requestMovieList];
}

#pragma mark - subview
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

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    YWReorderCastingViewController *vc = [[YWReorderCastingViewController alloc] init];
    _user.casting = _dataSource[_selectIndex];
    vc.user = _user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request
- (void)requestMovieList {
    [_httpManager requestInfoMovieTemplateList:nil success:^(id responseObject) {
        [_dataSource removeAllObjects];
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser movieWithArray:responseObject[@"castingList"]];
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
    cell.movie = _dataSource[indexPath.row];
    cell.state = (_selectIndex == indexPath.row)?YES:NO;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.row;
    [_collectionView reloadData];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}



@end
