//
//  YWEditMovieCallingCardViewController.m
//  ShowOn
//
//  Created by David Yu on 5/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWEditMovieCallingCardViewController.h"
#import "YWMovieCallingCardInfosView.h"
#import "YWMovieCallingCardCollectionViewCell.h"
#import "YWDataBaseManager.h"
#import "YWParser.h"
#import "YWHttpManager.h"
#import "YWUserModel.h"
#import "UMSocialSnsService.h"
#import "UMSocialData.h"
#import "UMSocial.h"
#import "YWHttpGlobalDefine.h"
#import "YWTrendsModel.h"
#import "YWPreviewMovieCardViewController.h"
#import "YWMovieCardModel.h"

@interface YWEditMovieCallingCardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@end

@implementation YWEditMovieCallingCardViewController
{
    NSMutableArray                  *_dataSource;
    UICollectionView                *_collectionView;
    YWHttpManager                   *_httpManager;
    NSInteger                        _selectIndex;
    BOOL                             _isShare;
    YWMovieCardModel                *_movieCard;
    YWMovieCallingCardInfosView     *_reusableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = @"制作视频";
    [self createRightItemWithTitle:@"完成"];
    _httpManager = [YWHttpManager shareInstance];
    _movieCard = [[YWMovieCardModel alloc] init];
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
    [_collectionView registerClass:[YWMovieCallingCardInfosView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    [_reusableview endEditing:YES];
    NSArray *array = @[@"请填写您的年龄", @"请填写您的三围", @"请填写您的身高", @"请选择您要制作视频名片的视频", @"请填写您的或邮箱"];
    if (!_movieCard.age.length) {
        [self showAlterWithTitle:array[0]];
        return;
    }else if (!_movieCard.bwh.length) {
        [self showAlterWithTitle:array[1]];
        return;
    }else if (!_movieCard.height.length) {
        [self showAlterWithTitle:array[2]];
        return;
    }else if (!_movieCard.email.length) {
        [self showAlterWithTitle:array[4]];
        return;
    }else if (_selectIndex == -1) {
        [self showAlterWithTitle:array[3]];
        return;
    }
    _movieCard.trends = _dataSource[_selectIndex];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [sheet addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _isShare = YES;
            [self requestCommitMovieCard];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestCommitMovieCard];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self preview];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:sheet animated:YES completion:nil];
    }else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享", @"保存", @"预览", nil];
        [sheet showInView:self.view];
    }
}

- (void)preview {
    YWPreviewMovieCardViewController *vc = [[YWPreviewMovieCardViewController alloc] init];
    vc.model = _movieCard;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        _isShare = YES;
        [self requestCommitMovieCard];
    }else if (buttonIndex == 1) {
        [self requestCommitMovieCard];
    }else if (buttonIndex == 2) {
        [self preview];
    }
}

#pragma mark - request
- (void)requestMovieList {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId};
    [_httpManager requestMovieList:parameters success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser trendsWithArray:responseObject[@"movieList"]];
        [_dataSource addObjectsFromArray:array];
        _selectIndex = _dataSource.count?0:-1;
        [_collectionView reloadData];
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

- (void)requestCommitMovieCard {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"authentication": _movieCard.authentication, @"address": _movieCard.address, @"bwh": _movieCard.bwh, @"age": _movieCard.age, @"constellation": _movieCard.constellation, @"height": _movieCard.height, @"announce": _movieCard.announce, @"email": _movieCard.email, @"info": _movieCard.info, @"trendsId": _movieCard.trends.trendsId};
    [_httpManager requestCommitMovieCard:parameters success:^(id responseObject) {
        _movieCard.cardId = responseObject[@"cardId"];
        if (_isShare) {
            [self requestShare];
        }else {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

- (void)requestShare {
    NSString *url = [NSString stringWithFormat:@"%@&cardId=%@", HOST_URL(Share_Movie_Method) , _movieCard.cardId];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMengAppKey shareText:@"来自【角儿】" shareImage:nil shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ] delegate:nil];
    NSString *title = _movieCard.info.length>0?_movieCard.info:@"";
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.url =  url;
    [UMSocialData defaultData].extConfig.qqData.title =  title;
    [UMSocialData defaultData].extConfig.qzoneData.title =  title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url =  url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =  url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title =  title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title =  title;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YWMovieCallingCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.model = _dataSource[indexPath.row];
    cell.state = (_selectIndex == indexPath.row)?YES:NO;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    _reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        _reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        _reusableview.model = _movieCard;
    }
    
    return _reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.row;
    [_collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 340);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


@end
