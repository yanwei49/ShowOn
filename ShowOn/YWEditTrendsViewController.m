//
//  YWEdithTrendsViewController.m
//  ShowOn
//
//  Created by David Yu on 25/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWEditTrendsViewController.h"

@interface YWEditTrendsViewController ()<UITextViewDelegate>

@end

@implementation YWEditTrendsViewController
{
    UIImageView    *_coverImageView;
    UILabel        *_templateNameLabel;
    UITextView     *_contentTextView;
    UILabel        *_placeholderLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    [self createRightItemWithTitle:@"存入草稿箱"];

}

- (void)createSubViews {
    UIButton *releaseButton = [[UIButton alloc] init];
    releaseButton.backgroundColor = RGBColor(30, 30, 30);
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(actionRelease:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseButton];
    [releaseButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(30);
    }];
    
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.backgroundColor = Subject_color;
    _coverImageView.image = nil;
    [self.view addSubview:_coverImageView];
    [_coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(200);
    }];
    
    _templateNameLabel = [[UILabel alloc] init];
    _templateNameLabel.backgroundColor = Subject_color;
    _templateNameLabel.font = [UIFont systemFontOfSize:14];
    _templateNameLabel.text = nil;
    [self.view addSubview:_templateNameLabel];
    [_templateNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(_coverImageView.mas_bottom);
    }];
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.backgroundColor = [UIColor whiteColor];
    _contentTextView.delegate = self;
    _contentTextView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_contentTextView];
    [_contentTextView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_templateNameLabel.mas_bottom);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(150);
    }];
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.font = [UIFont systemFontOfSize:14];
    _placeholderLabel.text = @"写点什么吧...";
    [self.view addSubview:_placeholderLabel];
    [_placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_templateNameLabel.mas_bottom);
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(20);
    }];
    
    NSArray *titles = @[@"", @""];
    NSArray *images = @[@"", @""];
    NSArray *selectImages = @[@"", @""];
    for (NSInteger i=0; i<2; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = Subject_color;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImages[i]] forState:UIControlStateSelected];
        [self.view addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentTextView.mas_bottom);
            make.left.offset(100*i+20);
            make.height.offset(20);
            make.width.offset(100);
        }];
    }
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {

}

- (void)actionRelease:(UIButton *)button {
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        _placeholderLabel.text = @"";
    }else {
        _placeholderLabel.text = @"写点什么吧...";
    }
}

@end
