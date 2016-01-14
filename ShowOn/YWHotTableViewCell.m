//
//  YWHotCollectionViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWMouldModel.h"

@implementation YWHotTableViewCell
{
    UIImageView    *_imageView;
    UILabel        *_nameLabel;
    UILabel        *_timeLabel;
    UIButton       *_playButton;
    UILabel        *_numsLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = Subject_color;

        UIView  *view = [[UIView alloc] init];
        view.backgroundColor = RGBColor(30, 30, 30);
        [self.contentView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.offset(-10);
        }];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(30, 30, 30);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [view addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(-40);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.height.offset(40);
            make.bottom.offset(0);
        }];
        
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _playButton.userInteractionEnabled = NO;
        [_playButton addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_playButton];
        [_playButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imageView.mas_centerY);
            make.centerX.equalTo(_imageView.mas_centerX);
            make.width.equalTo(_imageView.mas_width);
            make.height.equalTo(_imageView.mas_height);
        }];
        
        _numsLabel = [[UILabel alloc] init];
        _numsLabel.text = @"";
        _numsLabel.textColor = [UIColor whiteColor];
        _numsLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:_numsLabel];
        [_numsLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.height.offset(40);
            make.bottom.offset(0);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"";
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_numsLabel.mas_left).offset(-10);
            make.height.offset(40);
            make.bottom.offset(0);
        }];
    }
    
    return self;
}

- (void)actionPlay:(UIButton *)button {

}

- (void)setMould:(YWMouldModel *)mould {
    _mould = mould;
    _nameLabel.text = mould.mouldName;
    _timeLabel.text = [NSString stringWithFormat:@"时长%@", mould.mouldTimeLength];
    _numsLabel.text = [NSString stringWithFormat:@"拍摄次数%@", mould.mouldShootNums];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:mould.mouldCoverImage] placeholderImage:kPlaceholderMoiveImage];
}


@end
