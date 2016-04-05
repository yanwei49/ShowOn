//
//  YWMovieCallingCardCollectionViewCell.m
//  ShowOn
//
//  Created by David Yu on 5/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWMovieCallingCardCollectionViewCell.h"

@implementation YWMovieCallingCardCollectionViewCell
{
    UIImageView     *_imageView;
    UIButton        *_stateButton;
    UILabel         *_nameLabel;
    UILabel         *_timeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(30, 30, 30);
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
            make.bottom.offset(-20);
        }];
        
        _stateButton = [[UIButton alloc] init];
        [_stateButton setImage:[UIImage imageNamed:@"choose_normal_small.png"] forState:UIControlStateNormal];
        [_stateButton setImage:[UIImage imageNamed:@"choose_selected_small.png"] forState:UIControlStateSelected];
        [_stateButton addTarget:self action:@selector(actionOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_stateButton];
        [_stateButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(20);
            make.width.height.offset(25);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = RGBColor(30, 30, 30);
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(5);
            make.bottom.offset(0);
            make.height.offset(20);
            make.right.equalTo(self.contentView.mas_centerX);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = RGBColor(30, 30, 30);
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.bottom.offset(0);
            make.height.offset(20);
            make.left.equalTo(self.contentView.mas_centerX);
        }];
    }
    
    return self;
}

- (void)actionOnClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected && [_delegate respondsToSelector:@selector(movieCallingCardCollectionViewCellStateButtonWithSelected:)]) {
        [_delegate movieCallingCardCollectionViewCellStateButtonWithSelected:self];
    }
}

@end
