//
//  YWSuggestionViewController.m
//  ShowOn
//
//  Created by David Yu on 17/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWSuggestionViewController.h"

@interface YWSuggestionViewController ()<UITextViewDelegate>

@end

@implementation YWSuggestionViewController
{
    UITextView          *_textView;
    UILabel             *_placeholderLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户反馈";
}

#pragma mark - create
- (void)createSubViews {
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
        make.height.offset(150);
        make.right.offset(-10);
    }];
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.font = [UIFont systemFontOfSize:15];\
    _placeholderLabel.text = @"说点什么吧！";
    [self.view addSubview:_placeholderLabel];
    [_placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
        make.height.offset(15);
        make.right.offset(-10);
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        _placeholderLabel.text = @"";
    }else {
        _placeholderLabel.text = @"说点什么吧！";
    }
}



@end
