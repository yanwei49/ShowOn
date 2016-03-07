//
//  YWHotCollectionViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWMovieTemplateModel.h"
#import "YWMoviePlayView.h"
#import "YWTools.h"

@implementation YWHotTableViewCell
{
    UIImageView    *_imageView;
    UILabel        *_nameLabel;
    UILabel        *_timeLabel;
    UIButton       *_playButton;
    UILabel        *_numsLabel;
    YWMoviePlayView *_playMovieView;
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
        [_playButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_playButton];
        [_playButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imageView.mas_centerY);
            make.centerX.equalTo(_imageView.mas_centerX);
            make.width.height.offset(80);
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
        
        _playMovieView = [[YWMoviePlayView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 150) playUrl:@""];
        _playMovieView.backgroundColor = RGBColor(30, 30, 30);
        _playMovieView.layer.masksToBounds = YES;
        _playMovieView.layer.cornerRadius = 5;
        [self.contentView addSubview:_playMovieView];
    }
    
    return self;
}

- (void)actionPlay:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(hotTableViewCellDidSelectPlay:)]) {
        [_delegate hotTableViewCellDidSelectPlay:self];
    }
}

- (void)setTemplate:(YWMovieTemplateModel *)template {
    _template = template;
    _nameLabel.text = template.templateName;
    _timeLabel.text = [NSString stringWithFormat:@"时长 %@", [YWTools timMinuteStringWithUrl:template.templateVideoUrl]];
//    _timeLabel.text = [NSString stringWithFormat:@"时长%@", template.templateVideoTime];
    _numsLabel.text = [NSString stringWithFormat:@"拍摄次数%@", template.templatePlayUserNumbers];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:template.templateVideoCoverImage] placeholderImage:kPlaceholderMoiveImage];
    NSString *urlStr = template.templateVideoUrl;
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _imageView.image = [YWTools thumbnailImageRequestUrl:[NSURL URLWithString:urlStr] time:0];
//    _playMovieView.urlStr = template.templateVideoUrl;
    _playMovieView.hidden = YES;
//    _playButton.hidden = YES;
//    _imageView.hidden = YES;
}


@end
