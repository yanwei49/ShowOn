//
//  YWHotView.m
//  ShowOn
//
//  Created by David Yu on 12/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWHotView.h"

#import "YWHotCollectionViewCell.h"
#import "YWSearchCollectionReusableView.h"
#import "YWUserDataViewController.h"
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWHotListViewController.h"

#import "YWMovieModel.h"
#import "YWUserModel.h"

@interface YWHotView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YWHotCollectionViewCellDelegate>

@end

@implementation YWHotView
{
    NSMutableArray      *_dataSource;
    UICollectionView    *_collectionView;
    UISearchBar         *_searchBar;
}

+ (YWHotView *)shareInstance {
    static YWHotView *hotVC;
    if (!hotVC) {
        hotVC = [[YWHotView alloc] init];
    }
    
    return hotVC;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
        _dataSource = [[NSMutableArray alloc] init];
        
        [self createSubViews];
        [self dataSource];

    }
    return self;
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
    //    [_collectionView registerClass:[YWSearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    [self addSubview:_collectionView];
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

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - YWHotCollectionViewCellDelegate
- (void)hotCollectionViewCellDidSelectSupport:(YWHotCollectionViewCell *)cell {

}

- (void)hotCollectionViewCellDidSelectAvator:(YWHotCollectionViewCell *)cell {

}



@end
