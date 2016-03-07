//
//  YWTemplateViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTemplateViewController.h"
#import "YWTemplateCollectionViewCell.h"
#import "YWSearchCollectionReusableView.h"
#import "YWTemplateListViewController.h"
#import "YWSearchViewController.h"
#import "MJRefresh.h"
#import "YWParser.h"
#import "YWHttpManager.h"

@interface YWTemplateViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YWSearchCollectionReusableViewDelegate>

@end

@implementation YWTemplateViewController
{
    NSMutableArray      *_dataSource;
    UICollectionView    *_collectionView;
    YWHttpManager       *_httpManager;
    NSInteger            _currentPage;
    NSMutableArray      *_celebrityArray;
    NSMutableArray      *_vedioArray;
    NSMutableArray      *_applicationArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _dataSource = [[NSMutableArray alloc] init];
    _celebrityArray = [[NSMutableArray alloc] init];
    _vedioArray = [[NSMutableArray alloc] init];
    _applicationArray = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _currentPage = 0;

    [self createSubViews];
}

- (void)createSubViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-5)/2, 200);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = Subject_color;
    [_collectionView registerClass:[YWTemplateCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    [_collectionView registerClass:[YWSearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.offset(64);
    }];
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestSupportList];
    }];
}

#pragma mark - request
- (void)requestSupportList {
    [_httpManager requestTemplateSubCategory:nil success:^(id responseObject) {
        if (!_currentPage) {
            [_dataSource removeAllObjects];
            [_celebrityArray removeAllObjects];
            [_vedioArray removeAllObjects];
            [_applicationArray removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        [_celebrityArray addObjectsFromArray:[parser templateWithArray:responseObject[@"moreTemplate"][@"celebrityTemplate"]]];
        [_vedioArray addObjectsFromArray:[parser templateWithArray:responseObject[@"moreTemplate"][@"vedioTemplate"]]];
        [_applicationArray addObjectsFromArray:[parser templateWithArray:responseObject[@"moreTemplate"][@"applicationTemplate"]]];
        [self noContentViewShowWithState:_celebrityArray.count?NO:YES];
        _dataSource = _celebrityArray;
        if (_dataSource.count<20) {
            _collectionView.footer = nil;
        }else {
            _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestSupportList];
            }];
        }
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        [_collectionView reloadData];
    } otherFailure:^(id responseObject) {
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
    } failure:^(NSError *error) {
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YWTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.template = _dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        YWSearchCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
        headView.delegate = self;
        headView.itemShowState = NO;
        
        return headView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 90);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YWTemplateListViewController *vc = [[YWTemplateListViewController alloc] init];
    vc.template = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YWSearchCollectionReusableViewDelegate
- (void)searchCollectionReusableView:(YWSearchCollectionReusableView *)view didSelectItemWithIndex:(NSInteger)index {
    NSArray *array = @[_celebrityArray, _vedioArray, _applicationArray];
    _dataSource = array[index];
    [_collectionView reloadData];
}

- (void)searchCollectionReusableViewDidSelectSearchButton:(YWSearchCollectionReusableView *)view {
    YWSearchViewController *searchVC = [[YWSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
