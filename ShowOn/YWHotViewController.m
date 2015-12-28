//
//  YWHotViewController.m
//  ShowOn
//
//  Created by David Yu on 3/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHotViewController.h"
#import "YWHotCollectionViewCell.h"
#import "YWSearchCollectionReusableView.h"
#import "YWHotDetailViewController.h"
#import "YWUserDataViewController.h"
#import "YWHttpManager.h"
#import "YWParser.h"

#import "YWMovieModel.h"
#import "YWUserModel.h"

@interface YWHotViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YWHotCollectionViewCellDelegate>

@end

@implementation YWHotViewController
{
    NSMutableArray      *_dataSource;
    UICollectionView    *_collectionView;
    UISearchBar         *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _dataSource = [[NSMutableArray alloc] init];

    [self createSubViews];
    [self dataSource];
}

- (void)dataSource {
    for (NSInteger i=0; i<10; i++) {
        YWMovieModel *movie = [[YWMovieModel alloc] init];
        movie.movieId = [NSString stringWithFormat:@"%ld", i];
        movie.movieName = [NSString stringWithFormat:@"测试模板%ld", i+1];
        movie.movieIsSupport = [NSString stringWithFormat:@"%d", arc4random()%2];
        YWUserModel *user = [[YWUserModel alloc] init];
        user.userId = [NSString stringWithFormat:@"%ld", i];
        user.portraitUri = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        user.userName = [NSString stringWithFormat:@"测试用户%ld", i+1];
        movie.movieReleaseUser = user;
        
        [_dataSource addObject:movie];
    }
    [_collectionView reloadData];
}

- (void)createSubViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-5)/2, 200);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = Subject_color;
    [_collectionView registerClass:[YWHotCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
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
    YWHotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.delegate = self;
    cell.movie = _dataSource[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YWHotDetailViewController *vc = [[YWHotDetailViewController alloc] init];
    vc.movie = _dataSource[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.nv pushViewController:vc animated:YES];
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
        headView.itemShowState = YES;

        return headView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 40);
}

#pragma mark - YWHotCollectionViewCellDelegate
- (void)hotCollectionViewCellDidSelectSupport:(YWHotCollectionViewCell *)cell {
    if (false) {
        
    }else {
        [self login];
    }
}

- (void)hotCollectionViewCellDidSelectAvator:(YWHotCollectionViewCell *)cell {
    YWUserDataViewController *vc = [[YWUserDataViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.nv pushViewController:vc animated:YES];
}


@end
