//
//  YWMovieCallingCardInfosSView.m
//  ShowOn
//
//  Created by David Yu on 5/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWMovieCallingCardInfosView.h"
#import "YWMovieCardModel.h"
#import "YWUserModel.h"
#import "YWDataBaseManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YWMovieModel.h"

@interface YWMovieCallingCardInfosView()<UITextFieldDelegate>

@end

@implementation YWMovieCallingCardInfosView
{
    NSMutableArray      *_tfs;
    UIImageView    *_imageView;
    UIButton       *_playButton;
    UIButton       *_recorderButton;
    UIButton       *_supportButton;
    UILabel        *_supportLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
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
        [view addSubview:imageView1];
        [imageView1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(0);
            make.height.offset(60);
            make.width.offset(80);
        }];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = RGBColor(50, 50, 50);
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@"juer_title.png"];
        [view addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(-15);
            make.left.offset(85);
            make.height.offset(60);
            make.width.offset(150);
        }];
        
        UIView  *view1 = [[UIView alloc] init];
        view1.backgroundColor = RGBColor(50, 50, 50);
        [self addSubview:view1];
        [view1 makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(65);
            make.left.right.offset(0);
            make.height.offset(195);
        }];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(42, 42, 42);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 5;
        [view1 addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(-40);
        }];
        
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(actionPlay:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:_playButton];
        [_playButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_imageView.mas_centerY);
            make.centerX.equalTo(_imageView.mas_centerX);
            make.width.height.offset(80);
        }];
        
        _recorderButton = [[UIButton alloc] init];
        [_recorderButton setTitle:@"重新拍摄" forState:UIControlStateNormal];
        _recorderButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_recorderButton addTarget:self action:@selector(actionRecorder:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:_recorderButton];
        [_recorderButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.height.offset(30);
            make.bottom.offset(-5);
            make.width.offset(80);
        }];
        
        _supportLabel = [[UILabel alloc] init];
        _supportLabel.text = @"0";
        _supportLabel.textAlignment = NSTextAlignmentCenter;
        _supportLabel.textColor = [UIColor whiteColor];
        _supportLabel.font = [UIFont systemFontOfSize:15];
        [view1 addSubview:_supportLabel];
        [_supportLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.height.offset(20);
            make.bottom.offset(-10);
            make.width.offset(25);
        }];
        
        _supportButton = [[UIButton alloc] init];
        [_supportButton setImage:[UIImage imageNamed:@"support_normal.png"] forState:UIControlStateNormal];
        [_supportButton setImage:[UIImage imageNamed:@"support_selected.png"] forState:UIControlStateSelected];
        [_supportButton addTarget:self action:@selector(actionSupport:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:_supportButton];
        [_supportButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_supportLabel.mas_left);
            make.height.width.offset(20);
            make.bottom.offset(-10);
        }];

        _tfs = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"姓名:", @"地区:", @"年龄:", @"星座:", @"身高:", @"三围:", @"通告:", @"邮箱:", @"简介:"];
        NSArray *placeholders = @[@"请输入姓名", @"请输入地区", @"请输入年龄", @"请输入星座", @"请输入身高", @"请输入三围", @"请输入通告", @"请输入邮箱", @"请输入简介"];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = Subject_color;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.text = titles[0];
        [self addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(260);
            make.height.offset(40);
            make.left.equalTo(10);
            make.width.offset(40);
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
                make.top.offset(300+40*(i/2));
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
                make.top.offset(380+(i*40));
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

#pragma mark - action
- (void)actionPlay:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieCallingCardInfosViewDidSelectPlayButton)]) {
        [_delegate movieCallingCardInfosViewDidSelectPlayButton];
    }
}

- (void)actionRecorder:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieCallingCardInfosViewDidSelectRecorderButton)]) {
        [_delegate movieCallingCardInfosViewDidSelectRecorderButton];
    }
}

- (void)actionSupport:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(movieCallingCardInfosViewDidSelectSupportButton)]) {
        [_delegate movieCallingCardInfosViewDidSelectSupportButton];
    }
}

#pragma mark - get set
- (void)setModel:(YWMovieCardModel *)model {
    _model = model;
    for (NSInteger i=0; i<_tfs.count; i++) {
        UITextField *textField = _tfs[i];
        switch (i) {
            case 0:
                textField.text = model.authentication;
                break;
            case 1:
                textField.text = model.address;
                break;
            case 2:
                textField.text = model.age;
                break;
            case 3:
                textField.text = model.constellation;
                break;
            case 4:
                textField.text = model.height;
                break;
            case 5:
                textField.text = model.bwh;
                break;
            case 6:
                textField.text = model.announce;
                break;
            case 7:
                textField.text = model.email;
                break;
            case 8:
                textField.text = model.info;
                break;
            default:
                break;
        }
    }
}

- (void)setUser:(YWUserModel *)user {
    _user = user;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:user.casting.movieCoverImage?:@""] placeholderImage:kPlaceholderMoiveImage];
    _recorderButton.hidden = ([user.userId isEqualToString:[[YWDataBaseManager shareInstance] loginUser].userId])?NO:YES;
    _supportLabel.text = user.casting.movieSupports.length?user.casting.movieSupports:@"0";
    _supportButton.selected = user.casting.movieIsSupport.integerValue?YES:NO;
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    for (UITextField *tf in _tfs) {
        tf.userInteractionEnabled = isEdit;
    }
}

#pragma mark - UITextFieldDelegate
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
