//
//  YWSuggestionViewController.m
//  ShowOn
//
//  Created by David Yu on 17/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWSuggestionViewController.h"
#import "YWHttpManager.h"
#import "YWDataBaseManager.h"
#import "YWUserModel.h"

@interface YWSuggestionViewController ()<UITextViewDelegate>

@end

@implementation YWSuggestionViewController
{
    UITextView          *_textView;
    UILabel             *_placeholderLabel;
    YWHttpManager       *_httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户反馈";
    _httpManager = [YWHttpManager shareInstance];
    [self createRightItemWithTitle:@"提交"];
    
    [self createSubViews];
}

#pragma mark - create
- (void)createSubViews {
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(74);
        make.left.offset(10);
        make.height.offset(150);
        make.right.offset(-10);
    }];
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.font = [UIFont systemFontOfSize:15];
    _placeholderLabel.text = @"请留下您宝贵的意见吧！";
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_placeholderLabel];
    [_placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(84);
        make.left.offset(15);
        make.height.offset(15);
        make.right.offset(-10);
    }];
}

#pragma mark - actiom
- (void)actionRightItem:(UIButton *)button {
    [self requestSuggestion];
}

#pragma mark - request
- (void)requestSuggestion {
    if (![[YWDataBaseManager shareInstance] loginUser]) {
        [self login];
    }else if (!_textView.text.length) {
        [self showAlterWithTitle:@"请输入您的建议"];
    }else {
        NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"feedBackContents": _textView.text};
        [_httpManager requestFeedback:parameters success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        } otherFailure:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
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
