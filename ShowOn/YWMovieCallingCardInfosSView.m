//
//  YWMovieCallingCardInfosSView.m
//  ShowOn
//
//  Created by David Yu on 5/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWMovieCallingCardInfosSView.h"

@interface YWMovieCallingCardInfosSView()<UITextFieldDelegate>

@end

@implementation YWMovieCallingCardInfosSView
{
    NSMutableArray      *_tfs;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
        _tfs = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"认证信息:", @"地区:", @"年龄:", @"星座:", @"身高:", @"三围:", @"通告:", @"邮箱:"];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = Subject_color;
        imageView.image = [UIImage imageNamed:@""];
        [self addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.offset(0);
            make.left.offset(10);
            make.height.offset(60);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = Subject_color;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.text = titles[0];
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(60);
            make.height.offset(40);
            make.left.equalTo(10);
        }];
        
        UITextField *tf = [[UITextField alloc] init];
        tf.backgroundColor = Subject_color;
        tf.font = [UIFont systemFontOfSize:14];
        tf.textColor = [UIColor whiteColor];
        [self addSubview:tf];
        [_tfs addObject:tf];
        [tf makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_top);
            make.height.offset(40);
            make.left.equalTo(label.mas_right).offset(5);
            make.right.offset(0);
        }];

        for (NSInteger i=0; i<4; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = Subject_color;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            label.text = titles[i+1];
            [self addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(100+40*(i/2));
                make.height.offset(40);
                make.left.equalTo(kScreenWidth/2*(i%2)+10);
            }];
            
            UITextField *tf = [[UITextField alloc] init];
            tf.backgroundColor = Subject_color;
            tf.font = [UIFont systemFontOfSize:14];
            tf.textColor = [UIColor whiteColor];
            [self addSubview:tf];
            [_tfs addObject:tf];
            [tf makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_top);
                make.height.offset(40);
                make.left.equalTo(label.mas_right).offset(5);
                make.right.offset(kScreenWidth/2*(i%2-1));
            }];
        }
        
        for (NSInteger i=0; i<3; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = Subject_color;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            label.text = titles[4+i];
            [self addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(180+(i*40));
                make.height.offset(40);
                make.left.equalTo(10);
            }];
            
            UITextField *tf = [[UITextField alloc] init];
            tf.backgroundColor = Subject_color;
            tf.font = [UIFont systemFontOfSize:14];
            tf.textColor = [UIColor whiteColor];
            [self addSubview:tf];
            [_tfs addObject:tf];
            [tf makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_top);
                make.height.offset(40);
                make.left.equalTo(label.mas_right).offset(5);
                make.right.offset(0);
            }];
        }
    }
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

@end
