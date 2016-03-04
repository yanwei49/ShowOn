//
//  YWTemplateCollectionViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTemplateCollectionViewCell.h"
#import "YWMovieTemplateModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWSubsectionVideoModel.h"
#import "YWTools.h"

@implementation YWTemplateCollectionViewCell
{
    UIImageView   *_imageView;
    UILabel       *_nameLabel;
    UIView        *_blackView;
    UIImageView   *_downImageView;
    UIView        *_progressView;
    CGFloat        _totalTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = Subject_color;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = CornerRadius;
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;

        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = Subject_color;
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.offset(0);
        }];
        
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = RGBColor(30, 30, 30);
        [self.contentView addSubview:_blackView];
        [_blackView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(30);
        }];

        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(30);
        }];
        
        _downImageView = [[UIImageView alloc] init];
        _downImageView.backgroundColor = [UIColor blackColor];
        _downImageView.alpha = 0.8;
        [self.contentView addSubview:_downImageView];
        _downImageView.hidden = YES;
        [_downImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.top.offset(0);
        }];
        
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor redColor];
        _progressView.hidden = YES;
        [self.contentView addSubview:_progressView];
        [_progressView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(-20);
            make.bottom.offset(20);
            make.width.offset(1);
            make.left.offset(0);
        }];
    }
    
    return self;
}

static CGFloat cnt = 0;
- (void)startRecorderAnimationWithDuration:(CGFloat)time {
    cnt = 0;
    _totalTime = time;
    [self recorderAnimation];
}

- (void)recorderAnimation {
    CGFloat left = 110*cnt/_totalTime;
    [UIView animateWithDuration:0.1 animations:^{
        CGRect frame = _progressView.frame;
        frame.origin.x = left;
        _progressView.frame = frame;
        NSLog(@"=====================%f", left);
    }];
    cnt += 0.1;
    if (cnt<=_totalTime) {
        [self performSelector:@selector(recorderAnimation) withObject:self afterDelay:0.1];
    }else {
        [self stopRecorderAnimation];
    }
}

- (void)stopRecorderAnimation {
    cnt = 0;
    _progressView.hidden = YES;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _nameLabel.font = textFont;
}

- (void)setViewAlpha:(CGFloat)viewAlpha {
    _viewAlpha = viewAlpha;
    _blackView.alpha = viewAlpha;
}

- (void)setTemplate:(YWMovieTemplateModel *)template {
    _template = template;
    _nameLabel.text = template.templateName;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:template.templateVideoCoverImage] placeholderImage:kPlaceholderMoiveImage];
}

- (void)setSubsectionVideo:(YWSubsectionVideoModel *)subsectionVideo {
    [_progressView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(-20);
        make.bottom.offset(20);
        make.width.offset(1);
        make.left.offset(0);
    }];
    _subsectionVideo = subsectionVideo;
    _nameLabel.text = [NSString stringWithFormat:@"%@s", subsectionVideo.subsectionVideoTime?:@"0"];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:subsectionVideo.subsectionVideoCoverImage] placeholderImage:kPlaceholderMoiveImage];
    NSURL *url;
    if (subsectionVideo.recorderVideoUrl) {
        url = subsectionVideo.recorderVideoUrl;
    }else if (subsectionVideo.subsectionRecorderVideoUrl && subsectionVideo.subsectionRecorderVideoUrl.length) {
        NSString *urlStr = subsectionVideo.subsectionRecorderVideoUrl;
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:urlStr];
    }else {
        NSString *urlStr = subsectionVideo.subsectionVideoUrl;
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSURL URLWithString:urlStr];
    }
    _imageView.image = [YWTools thumbnailImageRequestUrl:url time:0];
    self.contentView.layer.borderColor = Subject_color.CGColor;
    self.contentView.layer.borderWidth = 0;
    _downImageView.hidden = YES;
    _progressView.hidden = YES;
    if (subsectionVideo.subsectionVideoPerformanceStatus.integerValue == 1) {
        _downImageView.hidden = NO;
    }else if (subsectionVideo.subsectionVideoPerformanceStatus.integerValue == 2) {
        _downImageView.hidden = YES;
    }else {
        _progressView.hidden = NO;
//        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.contentView.layer.borderWidth = 5;
    }
}


@end
