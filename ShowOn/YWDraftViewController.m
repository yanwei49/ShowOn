//
//  YWDraftViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWDraftViewController.h"
#import "YWDraftCollectionViewCell.h"
#import "YWTranscribeViewController.h"
#import "YWParser.h"
#import "YWHttpManager.h"
#import "YWUserModel.h"
#import "YWDataBaseManager.h"
#import "MJRefresh.h"

@interface YWDraftViewController()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation YWDraftViewController
{
    NSMutableArray      *_dataSource;
    UICollectionView    *_collectionView;
    YWHttpManager       *_httpManager;
    NSInteger            _currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _dataSource = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    _currentPage = 0;

    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestDraftList];
//    [_collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)createSubViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-5)/2, 200);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = Subject_color;
    [_collectionView registerClass:[YWDraftCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    _collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestDraftList];
    }];
}


#pragma mark - request
- (void)requestDraftList {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId};
    [_httpManager requestDraftList:parameters success:^(id responseObject) {
        if (!_currentPage) {
            [_dataSource removeAllObjects];
        }
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser trendsWithArray:responseObject[@"draftList"]];
        [_dataSource addObjectsFromArray:array];
        [self noContentViewShowWithState:_dataSource.count?NO:YES];
        if (array.count<20) {
            _collectionView.footer = nil;
        }else {
            _collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                _currentPage ++;
                [self requestDraftList];
            }];
        }
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        [_collectionView reloadData];
        [YWNoCotentView showNoCotentViewWithState:_dataSource.count?NO:YES];
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
    YWDraftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.trends = _dataSource[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
    vc.trends = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    vc.navigationController.navigationBarHidden = YES;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
