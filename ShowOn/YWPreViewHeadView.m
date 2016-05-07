//
//  YWPreViewHeadView.m
//  ShowOn
//
//  Created by David Yu on 29/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWPreViewHeadView.h"
#import "YWMovieCardModel.h"

@interface YWPreViewHeadView()<UITextFieldDelegate>

@end


@implementation YWPreViewHeadView
{
    NSMutableArray      *_tfs;
}

- (instancetype)initWithFrame:(CGRect)frame model:(YWMovieCardModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
        _tfs = [[NSMutableArray alloc] init];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBColor(50, 50, 50);
        [self addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(60);
        }];
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.backgroundColor = RGBColor(50, 50, 50);
        imageView1.image = [UIImage imageNamed:@"juer_.png"];
        [self addSubview:imageView1];
        [imageView1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.height.offset(60);
            make.width.offset(80);
        }];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = RGBColor(50, 50, 50);
        imageView.image = [UIImage imageNamed:@"juer_title.png"];
        [self addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(-15);
            make.left.offset(85);
            make.height.offset(60);
            make.width.offset(150);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = Subject_color;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.text = @"姓名:";
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(60);
            make.height.offset(40);
            make.left.equalTo(10);
            make.width.offset(40);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.backgroundColor = Subject_color;
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = [UIColor whiteColor];
        label1.text = model.authentication;
        [self addSubview:label1];
        [label1 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label.mas_centerY);
            make.height.offset(30);
            make.left.equalTo(label.mas_right).offset(5);
            make.right.offset(0);
        }];
        NSArray *titles;
        NSArray *contents;
        if (model.address.length && model.constellation.length) {
            titles = @[@"地区:", @"年龄:", @"星座:", @"身高:"];
            contents = @[model.address, model.age, model.constellation, model.height];
        }else if (model.address.length) {
            titles = @[@"地区:", @"年龄:", @"身高:"];
            contents = @[model.address, model.age, model.height];
        }else if (model.constellation.length) {
            titles = @[@"地区:", @"年龄:", @"星座:"];
            contents = @[model.address, model.age, model.constellation];
        }else {
            titles = @[@"地区:", @"年龄:"];
            contents = @[model.address, model.age];
        }
        UILabel *lastLabel;
        for (NSInteger i=0; i<titles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = Subject_color;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            label.text = titles[i];
            [self addSubview:label];
            lastLabel = label;
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(100+40*(i/2));
                make.height.offset(40);
                make.left.equalTo(kScreenWidth/2*(i%2)+10);
                make.width.offset(40);
            }];
            
            UILabel *label1 = [[UILabel alloc] init];
            label1.backgroundColor = Subject_color;
            label1.font = [UIFont systemFontOfSize:14];
            label1.textColor = [UIColor whiteColor];
            label1.text = contents[i];
            [self addSubview:label1];
            [label1 makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label.mas_centerY);
                make.height.offset(30);
                make.left.equalTo(label.mas_right).offset(5);
                make.right.offset(kScreenWidth/2*(i%2-1));
            }];
        }
        
        NSMutableArray *titles1 = [NSMutableArray array];
        NSMutableArray *contents1 = [NSMutableArray array];
        [titles1 addObject:@"三围:"];
        [contents1 addObject:model.bwh];
        if (model.announce.length) {
            [titles1 addObject:@"通告:"];
            [contents1 addObject:model.announce];
        }
        [titles1 addObject:@"邮箱:"];
        [contents1 addObject:model.email];
        if (model.info.length) {
            [titles1 addObject:@"简介:"];
            [contents1 addObject:model.info];
        }
        CGFloat h = 140;
        if (titles.count>2) {
            h += 40;
        }
        for (NSInteger i=0; i<titles1.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = Subject_color;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            label.text = titles1[i];
            [self addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(h+i*40);
                make.height.offset(40);
                make.left.equalTo(10);
                make.width.offset(40);
            }];
            
            UILabel *label1 = [[UILabel alloc] init];
            label1.backgroundColor = Subject_color;
            label1.font = [UIFont systemFontOfSize:14];
            label1.textColor = [UIColor whiteColor];
            label1.text = contents1[i];
            [self addSubview:label1];
            [label1 makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label.mas_centerY);
                make.height.offset(30);
                make.left.equalTo(label.mas_right).offset(5);
                make.right.offset(0);
            }];
        }
    }
    
    return self;
}


@end
