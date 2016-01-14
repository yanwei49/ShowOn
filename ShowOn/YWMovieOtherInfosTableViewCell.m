//
//  YWMovieOtherInfosTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/27.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWMovieOtherInfosTableViewCell.h"
#import "YWMovieModel.h"
#import "YWUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YWMovieOtherInfosTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation YWMovieOtherInfosTableViewCell
{
    UILabel            *_userNameLabel;
    UIButton           *_moreButton;
    UIButton           *_supportButton;
    UIButton           *_collectButton;
    UILabel            *_supportLabel;
    UILabel            *_collectLabel;
    UICollectionView   *_collectionView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(42, 42, 42);
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = RGBColor(42, 42, 42);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"他们也在演：";
        [self.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.height.offset(40);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(50, 40);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = Subject_color;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"item"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.contentView addSubview:_collectionView];
        [_collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.equalTo(label.mas_right);
            make.width.offset(200);
            make.height.offset(40);
        }];

        _moreButton = [[UIButton alloc] init];
        _moreButton.backgroundColor = RGBColor(42, 42, 42);
        [_moreButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(actionOnClickMore:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_moreButton];
        [_moreButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_collectionView.mas_centerY);
            make.right.offset(-10);
            make.height.width.offset(30);
        }];
        
        UIButton *supportButton = [[UIButton alloc] init];
        supportButton.backgroundColor = RGBColor(42, 42, 42);
        [supportButton addTarget:self action:@selector(actionOnClickSupport:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:supportButton];
        [supportButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_collectionView.mas_bottom).offset(10);
            make.left.offset(10);
            make.height.offset(30);
            make.width.offset(70);
        }];
        
        UIButton *collectButton = [[UIButton alloc] init];
        collectButton.backgroundColor = RGBColor(42, 42, 42);
        [collectButton addTarget:self action:@selector(actionOnClickCollect:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:collectButton];
        [collectButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(supportButton.mas_top);
            make.left.equalTo(supportButton.mas_right).offset(20);
            make.height.offset(30);
            make.width.offset(70);
        }];
        
        UIButton *shareButton = [[UIButton alloc] init];
        shareButton.backgroundColor = RGBColor(42, 42, 42);
        [shareButton addTarget:self action:@selector(actionOnClickShare:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:shareButton];
        [shareButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(supportButton.mas_top);
            make.right.offset(-10);
            make.height.offset(30);
            make.width.offset(120);
        }];

        _supportButton = [[UIButton alloc] init];
        _supportButton.backgroundColor = RGBColor(42, 42, 42);
        _supportButton.userInteractionEnabled = NO;
        [_supportButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_supportButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [supportButton addSubview:_supportButton];
        [_supportButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(supportButton.mas_centerY);
            make.left.offset(0);
            make.width.height.offset(20);
        }];
        
        _supportLabel = [[UILabel alloc] init];
        _supportLabel.backgroundColor = RGBColor(42, 42, 42);
        _supportLabel.text = @"0";
        _supportLabel.textColor = [UIColor whiteColor];
        _supportLabel.font = [UIFont systemFontOfSize:13];
        [supportButton addSubview:_supportLabel];
        [_supportLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_supportButton.mas_centerY);
            make.left.equalTo(_supportButton.mas_right).offset(5);
            make.height.offset(20);
        }];
        
        _collectButton = [[UIButton alloc] init];
        _collectButton.backgroundColor = RGBColor(42, 42, 42);
        _collectButton.userInteractionEnabled = NO;
        [_collectButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [collectButton addSubview:_collectButton];
        [_collectButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_supportButton.mas_centerY);
            make.left.offset(0);
            make.width.height.offset(20);
        }];
        
        _collectLabel = [[UILabel alloc] init];
        _collectLabel.backgroundColor = RGBColor(42, 42, 42);
        _collectLabel.text = @"收藏";
        _collectLabel.textColor = [UIColor whiteColor];
        _collectLabel.font = [UIFont systemFontOfSize:13];
        [collectButton addSubview:_collectLabel];
        [_collectLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_supportButton.mas_centerY);
            make.left.equalTo(_collectButton.mas_right).offset(5);
            make.height.offset(20);
        }];
        
        UILabel *shareLab = [[UILabel alloc] init];
        shareLab.backgroundColor = RGBColor(42, 42, 42);
        shareLab.text = @"转发/分享";
        shareLab.textColor = [UIColor whiteColor];
        shareLab.font = [UIFont systemFontOfSize:13];
        [shareButton addSubview:shareLab];
        [shareLab makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_supportButton.mas_centerY);
            make.right.offset(0);
            make.height.offset(20);
        }];

        UIButton *shareBtn = [[UIButton alloc] init];
        shareBtn.backgroundColor = RGBColor(42, 42, 42);
        shareBtn.userInteractionEnabled = NO;
        [shareBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [shareButton addSubview:shareBtn];
        [shareBtn makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_supportButton.mas_centerY);
            make.right.equalTo(shareLab.mas_left).offset(-5);
            make.width.height.offset(20);
        }];
    }
    
    return self;
}

- (void)actionOnClickMore:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieOtherInfosTableViewCellDidSelectSupport:)]) {
        [_delegate movieOtherInfosTableViewCellDidSelectSupport:self];
    }
}

- (void)actionOnClickSupport:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieOtherInfosTableViewCellDidSelectSupport:)]) {
        [_delegate movieOtherInfosTableViewCellDidSelectSupport:self];
    }
}

- (void)actionOnClickCollect:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieOtherInfosTableViewCellDidSelectCollect:)]) {
        [_delegate movieOtherInfosTableViewCellDidSelectCollect:self];
    }
}

- (void)actionOnClickShare:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieOtherInfosTableViewCellDidSelectShare:)]) {
        [_delegate movieOtherInfosTableViewCellDidSelectShare:self];
    }
}

- (void)setMovie:(YWMovieModel *)movie {
    _movie = movie;
    _supportButton.selected = movie.movieIsSupport;
    _collectButton.selected = movie.movieIsCollect;
    _supportLabel.text = movie.movieSupports;
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _movie.moviePlayers.count>4?4:_movie.moviePlayers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    [cell.contentView.subviews.lastObject removeFromSuperview];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 20;
    imageView.backgroundColor = [UIColor whiteColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[_movie.moviePlayers[indexPath.row] portraitUri]] placeholderImage:kPlaceholderMoiveImage];
    [cell.contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.offset(40);
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(movieOtherInfosTableViewCell:didSelectUserAvator:)]) {
        [_delegate movieOtherInfosTableViewCell:self didSelectUserAvator:_movie.moviePlayers[indexPath.row]];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


@end
