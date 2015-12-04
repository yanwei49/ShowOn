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

@interface YWTemplateViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YWSearchCollectionReusableViewDelegate>

@end

@implementation YWTemplateViewController
{
    NSMutableArray      *_dataSource;
    UICollectionView    *_collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = [[NSMutableArray alloc] init];
    
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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-2)/2, 80);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = SeparatorColor;
    [_collectionView registerClass:[YWTemplateCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    [_collectionView registerClass:[YWSearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YWTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 70);
}

#pragma mark - YWSearchCollectionReusableViewDelegate
- (void)searchCollectionReusableView:(YWSearchCollectionReusableView *)view didSelectItemWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [_dataSource removeAllObjects];
            for (NSInteger i=0; i<10; i++) {
                [_dataSource addObject:@""];
            }
            break;
        case 1:
            [_dataSource removeAllObjects];
            for (NSInteger i=0; i<4; i++) {
                [_dataSource addObject:@""];
            }
            break;
        case 2:
            [_dataSource removeAllObjects];
            for (NSInteger i=0; i<7; i++) {
                [_dataSource addObject:@""];
            }
            break;
        default:
            break;
    }
    [_collectionView reloadData];
}

@end
