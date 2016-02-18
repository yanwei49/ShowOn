//
//  YWTemplatListTableViewCell.m
//  ShowOn
//
//  Created by David Yu on 14/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWTemplateListTableViewCell.h"
#import "YWMovieTemplateModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YWTemplateListTableViewCell
{
    UIImageView    *_imageView;
    UILabel        *_nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = Subject_color;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBColor(50, 50, 50);
        [self.contentView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.bottom.offset(-5);
        }];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(50, 50, 50);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [view addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.top.bottom.offset(0);
            make.width.offset(100);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = RGBColor(50, 50, 50);
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_right).offset(10);
            make.right.offset(-10);
            make.centerY.equalTo(view.mas_centerY);
            make.height.offset(20);
        }];
        
        UIImageView *playImage = [[UIImageView alloc] init];
        playImage.backgroundColor = RGBColor(50, 50, 50);
        playImage.image = [UIImage imageNamed:@"play_big.png"];
        [_imageView addSubview:playImage];
        [playImage makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.centerY.equalTo(view.mas_centerY);
            make.width.height.offset(40);
        }];
    }
    
    return self;
}

- (void)setTemplate:(YWMovieTemplateModel *)template {
    _template = template;
    _nameLabel.text = template.templateName;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:template.templateVideoCoverImage] placeholderImage:kPlaceholderMoiveImage];
}


@end
