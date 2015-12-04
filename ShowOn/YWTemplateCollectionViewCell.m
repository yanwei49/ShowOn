//
//  YWTemplateCollectionViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWTemplateCollectionViewCell.h"

@implementation YWTemplateCollectionViewCell
{
    UIImageView   *_imageView;
    UILabel       *_nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor greenColor];
        _imageView.layer.cornerRadius = 30;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.offset(60);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imageView.mas_centerY);
            make.left.equalTo(_imageView.mas_right).offset(10);
            make.height.offset(20);
        }];
    }
    
    return self;
}

@end
