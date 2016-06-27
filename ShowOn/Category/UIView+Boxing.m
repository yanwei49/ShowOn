//
//  UIView+Boxing.m
//  GoFarm-V1.2.0
//
//  Created by David Yu on 8/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "UIView+Boxing.h"

@implementation UIView (Boxing)

- (void)addBoxWithOrientation:(BoxingOrientation)orientation withSize:(CGFloat)size {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BorderColorColor;
    [self addSubview:lineView];
    if (self.frame.size.width) {
        switch (orientation) {
            case kTop:
                lineView.frame = CGRectMake(0, 0, self.frame.size.width, size);
                break;
            case kLeft:
                lineView.frame = CGRectMake(0, 0, size, self.frame.size.height);
                break;
            case kRight:
                lineView.frame = CGRectMake(self.frame.size.width-size, 0, size, self.frame.size.height);
                break;
            default:
                lineView.frame = CGRectMake(0, self.frame.size.height-size, self.frame.size.width, size);
                break;
        }
    }else {
        switch (orientation) {
            case kTop:
                {
                    [lineView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.offset(0);
                        make.width.equalTo(self.mas_width);
                        make.height.offset(size);
                    }];
                }
                break;
            case kLeft:
                {
                    [lineView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.offset(0);
                        make.height.equalTo(self.mas_height);
                        make.width.offset(size);
                    }];
                }
                break;
            case kRight:
                {
                    [lineView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.right.offset(0);
                        make.height.equalTo(self.mas_height);
                        make.width.offset(size);
                    }];
                }
                break;
            default:
                {
                    [lineView makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.left.offset(0);
                        make.height.offset(size);
                        make.width.equalTo(self.mas_width);
                    }];
                }
                break;
        }
    }
}

- (void)addBoxWithOrientations:(NSArray *)orientations withSize:(CGFloat)size {
    for (NSInteger i=0; i<orientations.count; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = BorderColorColor;
        [self addSubview:lineView];
        if (self.frame.size.width) {
            switch ([orientations[i] integerValue]) {
                case kTop:
                    lineView.frame = CGRectMake(0, 0, self.frame.size.width, size);
                    break;
                case kLeft:
                    lineView.frame = CGRectMake(0, 0, size, self.frame.size.height);
                    break;
                case kRight:
                    lineView.frame = CGRectMake(self.frame.size.width-size, 0, size, self.frame.size.height);
                    break;
                default:
                    lineView.frame = CGRectMake(0, self.frame.size.height-size, self.frame.size.width, size);
                    break;
            }
        }else {
            switch ([orientations[i] integerValue]) {
                case kTop:
                {
                    [lineView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.offset(0);
                        make.width.equalTo(self.mas_width);
                        make.height.offset(size);
                    }];
                }
                    break;
                case kLeft:
                {
                    [lineView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.offset(0);
                        make.height.equalTo(self.mas_height);
                        make.width.offset(size);
                    }];
                }
                    break;
                case kRight:
                {
                    [lineView makeConstraints:^(MASConstraintMaker *make) {
                        make.top.right.offset(0);
                        make.height.equalTo(self.mas_height);
                        make.width.offset(size);
                    }];
                }
                    break;
                default:
                {
                    [lineView makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.left.offset(0);
                        make.height.offset(size);
                        make.width.equalTo(self.mas_width);
                    }];
                }
                    break;
            }
        }
    }
}

@end
