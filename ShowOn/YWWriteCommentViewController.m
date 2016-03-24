//
//  YWWriteCommentViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/27.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWWriteCommentViewController.h"
#import "YWKeyboardHeadView.h"
#import "YWUserListViewController.h"
#import "YWUserModel.h"
#import "YWHttpManager.h"
#import "YWTrendsModel.h"
#import "YWCommentModel.h"
#import "YWDataBaseManager.h"
#import "YWMovieTemplateModel.h"
#import "YWTrendsModel.h"

@implementation UIView (AnimationOptionsForCurve)

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}

@end

@interface YWWriteCommentViewController ()<YWKeyboardHeadViewDelegate, UITextViewDelegate, YWUserListViewControllerDelegate>

@end

@implementation YWWriteCommentViewController
{
    YWKeyboardHeadView  *_keyboardHead;
    UITextView          *_textView;
    UILabel             *_placeholderLabel;
    NSMutableArray      *_selectUsers;
    YWHttpManager       *_httpManager;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)dealloc {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    [self createRightItemWithTitle:@"发布"];
    [self createLeftItemWithTitle:@"取消"];
    _selectUsers = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];

    [self createSubViews];
}

#pragma mark - create
- (void)createSubViews {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = Subject_color;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    if (_type == 3) {
        label.text = [NSString stringWithFormat:@"转发动态：%@", _trends.trendsContent?:@""];
    }else if (_type == 2 || _type == 5) {
        label.text = [NSString stringWithFormat:@"回复评论：%@", _comment.commentContent?:@""];
    }else if (_type == 1) {
        label.text = [NSString stringWithFormat:@"评论动态：%@", _trends.trendsContent?:@""];
    }else if (_type == 4) {
        label.text = [NSString stringWithFormat:@"评论模板：%@", _template.templateName?:@""];
    }
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(64+5);
        make.left.offset(10);
        make.height.offset(20);
        make.right.offset(-40);
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20+10+64);
        make.left.offset(10);
        make.height.offset(150);
        make.right.offset(-10);
    }];
    
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.font = [UIFont systemFontOfSize:15];
    _placeholderLabel.text = @"说点什么吧！";
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_placeholderLabel];
    [_placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20+18+64);
        make.left.offset(15);
        make.height.offset(15);
        make.right.offset(-10);
    }];
    
    if (_type != 3) {
        _keyboardHead = [[YWKeyboardHeadView alloc] init];
        _keyboardHead.delegate = self;
        [self.view addSubview:_keyboardHead];
        [_keyboardHead makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(49);
        }];
    }
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    if (![[YWDataBaseManager shareInstance] loginUser]) {
        [self login];
    }else if (!_textView.text.length) {
        [self showAlterWithTitle:@"说的什么吧！"];
    }else {
        if (_type == 3) {
            [self requestRepeat];
        }else {
            [self requestCommitContent];
        }
    }
}

- (void)actionLeftItem:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - request
- (void)requestCommitContent {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SVProgressHUD showWithStatus:@"提交中，请稍等。。。"];
    NSMutableString *userId = [NSMutableString stringWithString:@""];
    for (YWUserModel *user in _selectUsers) {
        if ([_textView.text rangeOfString:[NSString stringWithFormat:@"@%@", user.userName]].location != NSNotFound) {
            [userId appendString:user.userId];
            [userId appendString:@"|"];
        }
    }
    NSString *dependId = @"";
    NSString *commentsTypeId = @"1";
    NSString *commentsTargetId = @"";
    NSString *dependType = @"";
    if (_type == 2) {
        dependId = _trends.trendsId;
        commentsTypeId = @"2";
        commentsTargetId = _comment.commentId;
        dependType = @"1";
    }else if (_type == 5) {
        dependId = _template.templateId;
        commentsTypeId = @"2";
        commentsTargetId = _comment.commentId;
        dependType = @"2";
    }else if (_type == 1) {
        dependId = _trends.trendsId;
        commentsTypeId = @"1";
        commentsTargetId = _trends.trendsId;
        dependType = @"1";
    }else if (_type == 4) {
        commentsTargetId = _comment.commentId;
        commentsTypeId = @"3";
        commentsTargetId = _template.templateId;
        dependType = @"2";
    }
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"commentsTargetId": commentsTargetId, @"commentsTypeId": commentsTypeId, @"commentsContent": _textView.text, @"aiTeuserIds": userId, @"dependId": dependId, @"dependType": dependType};
    [_httpManager requestCommitComment:parameters success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } otherFailure:^(id responseObject) {
        [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (void)requestRepeat {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"trendsId": _trends.trendsId, @"forwardComments": @(2)};
    [_httpManager requestRepeat:parameters success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
        [self dismissViewControllerAnimated:YES completion:nil];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - YWKeyboardHeadViewDelegate
- (void)keyboardHeadViewButtonOnClick {
    YWUserListViewController *vc = [[YWUserListViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YWUserListViewControllerDelegate
- (void)userListViewControllerDidSelectUsers:(NSArray *)users {
    [_selectUsers addObjectsFromArray:users];
    NSMutableString *names = [NSMutableString string];
    for (YWUserModel *user in users) {
        [names appendString:@"@"];
        [names appendString:user.userName];
    }
    _textView.text = [NSString stringWithFormat:@"%@%@", _textView.text, names];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        _placeholderLabel.text = @"";
    }else {
        _placeholderLabel.text = @"说点什么吧！";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [_keyboardHead mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-keyboardRect.size.height);
    }];
    [UIView animateWithDuration:duration delay:0.0f options:[UIView animationOptionsForCurve:curve] animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
    completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [_keyboardHead mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [UIView animateWithDuration:duration delay:0.0f options:[UIView animationOptionsForCurve:curve] animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
    completion:^(BOOL finished) {
    }];
}


@end
