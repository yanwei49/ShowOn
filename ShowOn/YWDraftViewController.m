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

@interface YWDraftViewController()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation YWDraftViewController
{
    NSMutableArray      *_dataSource;
    UICollectionView    *_collectionView;
    YWHttpManager       *_httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _dataSource = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];

    [self createSubViews];
//    [self dataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestDraftList];
}

//- (void)dataSource {
//    for (NSInteger i=0; i<10; i++) {
//        [_dataSource addObject:@""];
//    }
//    [_collectionView reloadData];
//}
//
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
}


#pragma mark - request
- (void)requestDraftList {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId};
    [_httpManager requestDraftList:parameters success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser trendsWithArray:responseObject[@"draftList"]];
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
    YWDraftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.trends = _dataSource[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
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
