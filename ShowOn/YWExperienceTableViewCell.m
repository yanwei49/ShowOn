


//
//  YWExperienceTableViewCell.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWExperienceTableViewCell.h"

@implementation YWExperienceTableViewCell
{
    UILabel     *_titleLabel;
    UILabel     *_infoLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBColor(50, 50, 50);
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = RGBColor(230, 230, 230);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(20);
        }];
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:15];
        _infoLabel.textColor = RGBColor(230, 230, 230);
        [self.contentView addSubview:_infoLabel];
        [_infoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.right.offset(-20);
        }];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setInfo:(NSString *)info {
    _info = info;
    _infoLabel.text = info;
}

@end
