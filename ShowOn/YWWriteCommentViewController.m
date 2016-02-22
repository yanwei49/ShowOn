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
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10+64);
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
        make.top.offset(18+64);
        make.left.offset(15);
        make.height.offset(15);
        make.right.offset(-10);
    }];
    
    _keyboardHead = [[YWKeyboardHeadView alloc] init];
    _keyboardHead.delegate = self;
    [self.view addSubview:_keyboardHead];
    [_keyboardHead makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(49);
    }];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    if (![[YWDataBaseManager shareInstance] loginUser]) {
        [self login];
    }else if (!_textView.text.length) {
        [self showAlterWithTitle:@"说的什么吧！"];
    }else {
        [self requestCommitContent];
    }
}

- (void)actionLeftItem:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - request
- (void)requestCommitContent {
    NSMutableString *userId = [NSMutableString stringWithString:@""];
    for (YWUserModel *user in _selectUsers) {
        if ([_textView.text rangeOfString:[NSString stringWithFormat:@"@%@", user.userName]].location != NSNotFound) {
            [userId appendString:user.userId];
            [userId appendString:@"|"];
        }
    }
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"commentsTargetId": _trends&&_comment?_trends.trendsId:_comment.commentId, @"commentsTypeId": _trends?@(1):@(2), @"commentsContent": _textView.text, @"aiTeuserIds": userId, @"dependId": _template?_template.templateId:_trends.trendsId, @"dependType": _template?@(2):@(1)};
    [_httpManager requestAiTeList:parameters success:^(id responseObject) {
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

@end
