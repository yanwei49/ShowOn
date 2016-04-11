//
//  YWMovieCallingCardInfosSView.m
//  ShowOn
//
//  Created by David Yu on 5/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWMovieCallingCardInfosView.h"
#import "YWMovieCardModel.h"

@interface YWMovieCallingCardInfosView()<UITextFieldDelegate>

@end

@implementation YWMovieCallingCardInfosView
{
    NSMutableArray      *_tfs;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
        _tfs = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"认证信息:", @"地区:", @"年龄:", @"星座:", @"身高:", @"三围:", @"通告:", @"邮箱:", @"简介:"];
        NSArray *placeholders = @[@"请输入认证信息", @"请输入地区", @"请输入年龄", @"请输入星座", @"请输入身高", @"请输入三围", @"请输入通告", @"请输入邮箱", @"请输入简介"];
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
            make.top.offset(15);
            make.left.offset(85);
            make.height.offset(30);
            make.width.offset(150);
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
            make.width.offset(70);
        }];
        
        UITextField *tf = [[UITextField alloc] init];
        tf.backgroundColor = Subject_color;
        tf.font = [UIFont systemFontOfSize:14];
        tf.textColor = [UIColor whiteColor];
        tf.delegate = self;
        tf.placeholder = placeholders[0];
        [tf setValue:RGBColor(100, 100, 100) forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:tf];
        [_tfs addObject:tf];
        [tf makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label.mas_centerY);
            make.height.offset(30);
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
                make.width.offset(40);
            }];
            
            UITextField *tf = [[UITextField alloc] init];
            tf.backgroundColor = Subject_color;
            tf.font = [UIFont systemFontOfSize:14];
            tf.textColor = [UIColor whiteColor];
            tf.placeholder = placeholders[i+1];
            tf.delegate = self;
            [tf setValue:RGBColor(100, 100, 100) forKeyPath:@"_placeholderLabel.textColor"];
            [self addSubview:tf];
            [_tfs addObject:tf];
            [tf makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label.mas_centerY);
                make.height.offset(30);
                make.left.equalTo(label.mas_right).offset(5);
                make.right.offset(kScreenWidth/2*(i%2-1));
            }];
        }
        
        for (NSInteger i=0; i<4; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = Subject_color;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            label.text = titles[5+i];
            [self addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(180+(i*40));
                make.height.offset(40);
                make.left.equalTo(10);
                make.width.offset(40);
            }];
            
            UITextField *tf = [[UITextField alloc] init];
            tf.backgroundColor = Subject_color;
            tf.font = [UIFont systemFontOfSize:14];
            tf.textColor = [UIColor whiteColor];
            tf.placeholder = placeholders[i+5];
            tf.delegate = self;
            [tf setValue:RGBColor(100, 100, 100) forKeyPath:@"_placeholderLabel.textColor"];
            [self addSubview:tf];
            [_tfs addObject:tf];
            [tf makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(label.mas_centerY);
                make.height.offset(30);
                make.left.equalTo(label.mas_right).offset(5);
                make.right.offset(0);
            }];
        }
    }
    
    return self;
}

- (void)setModel:(YWMovieCardModel *)model {
    _model = model;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch ([_tfs indexOfObject:textField]) {
        case 0:
            _model.authentication = textField.text;
            break;
        case 1:
            _model.address = textField.text;
            break;
        case 2:
            _model.age = textField.text;
            break;
        case 3:
            _model.constellation = textField.text;
            break;
        case 4:
            _model.height = textField.text;
            break;
        case 5:
            _model.bwh = textField.text;
            break;
        case 6:
            _model.announce = textField.text;
            break;
        case 7:
            _model.email = textField.text;
            break;
        case 8:
            _model.info = textField.text;
            break;
        default:
            break;
    }
}

@end
