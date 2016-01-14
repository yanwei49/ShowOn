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

#import "YWMouldTypeModel.h"

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
    [self dataSourceWithIndex:10];
}

- (void)dataSourceWithIndex:(NSInteger)index {
    for (NSInteger i=0; i<index; i++) {
        YWMouldTypeModel *mouldType = [[YWMouldTypeModel alloc] init];
        mouldType.mouldTypeId = @"1";
        mouldType.mouldType = arc4random()%3;
        mouldType.mouldTypeName = [NSString stringWithFormat:@"名称%ld", (long)i];
        mouldType.mouldTypeImageUrl = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";

        [_dataSource addObject:mouldType];
    }
    [_collectionView reloadData];
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
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YWTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.moudlType = _dataSource[indexPath.row];
    
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
    vc.mouldType = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YWSearchCollectionReusableViewDelegate
- (void)searchCollectionReusableView:(YWSearchCollectionReusableView *)view didSelectItemWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [_dataSource removeAllObjects];
            [self dataSourceWithIndex:10];
            break;
        case 1:
            [_dataSource removeAllObjects];
            [self dataSourceWithIndex:4];
            break;
        case 2:
            [_dataSource removeAllObjects];
            [self dataSourceWithIndex:7];
            break;
        default:
            break;
    }
    [_collectionView reloadData];
}

@end
