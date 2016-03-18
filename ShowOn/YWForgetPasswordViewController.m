//
//  YWForgetPasswordViewController.m
//  ShowOn
//
//  Created by David Yu on 5/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWForgetPasswordViewController.h"
#import "NSString+isValidate.h"
#import "YWHttpManager.h"

@interface YWForgetPasswordViewController ()<UITextFieldDelegate>

@end

@implementation YWForgetPasswordViewController
{
    UITextField    *_accountTextField;
    UITextField    *_passwordTextField;
    UITextField    *_repeatPasswordTextField;
    UITextField    *_verificationTextField;
    UIButton       *_sendVerificationButton;
    UIButton       *_resetButton;
    NSString       *_verificationCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [self createBackButton];
    [self createSubViews];
}

-(void)dealloc {
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)createBackButton {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = Subject_color;
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor =[UIColor lightGrayColor].CGColor;
    [self.view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(70);
        make.height.offset(30);
        make.left.offset(20);
        make.top.offset(30);
    }];
}


- (void)createSubViews {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = Subject_color;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"找回角儿JUER账号密码";
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(25);
    }];
    
    _accountTextField = [[UITextField alloc] init];
    _accountTextField.backgroundColor = [UIColor whiteColor];
    _accountTextField.font = [UIFont systemFontOfSize:16];
    _accountTextField.delegate = self;
    _accountTextField.layer.cornerRadius = 5;
    _accountTextField.layer.masksToBounds = YES;
    _accountTextField.layer.borderWidth = 1;
    _accountTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _accountTextField.placeholder = @" 手机号";
    _accountTextField.font = [UIFont systemFontOfSize:16];
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_accountTextField];
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(30);
        make.width.offset(kScreenWidth-80);
    }];
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.delegate = self;
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.layer.cornerRadius = 5;
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.borderWidth = 1;
    _passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _passwordTextField.placeholder = @" 新密码";
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(30);
        make.width.offset(kScreenWidth-80);
    }];
    
    _repeatPasswordTextField = [[UITextField alloc] init];
    _repeatPasswordTextField.delegate = self;
    _repeatPasswordTextField.font = [UIFont systemFontOfSize:16];
    _repeatPasswordTextField.backgroundColor = [UIColor whiteColor];
    _repeatPasswordTextField.layer.cornerRadius = 5;
    _repeatPasswordTextField.layer.masksToBounds = YES;
    _repeatPasswordTextField.layer.borderWidth = 1;
    _repeatPasswordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _repeatPasswordTextField.placeholder = @" 确认密码";
    _repeatPasswordTextField.font = [UIFont systemFontOfSize:16];
    _repeatPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_repeatPasswordTextField];
    [_repeatPasswordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(30);
        make.width.offset(kScreenWidth-80);
    }];
    
    _verificationTextField = [[UITextField alloc] init];
    _verificationTextField.font = [UIFont systemFontOfSize:16];
    _verificationTextField.delegate = self;
    _verificationTextField.backgroundColor = [UIColor whiteColor];
    _verificationTextField.layer.cornerRadius = 5;
    _verificationTextField.layer.masksToBounds = YES;
    _verificationTextField.layer.borderWidth = 1;
    _verificationTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _verificationTextField.placeholder = @" 验证码";
    _verificationTextField.font = [UIFont systemFontOfSize:16];
    _verificationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_verificationTextField];
    [_verificationTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_repeatPasswordTextField.mas_bottom).offset(10);
        make.left.equalTo(_repeatPasswordTextField.mas_left);
        make.height.offset(30);
        make.width.offset(kScreenWidth-180);
    }];
    
    _sendVerificationButton = [[UIButton alloc] init];
    _sendVerificationButton.layer.cornerRadius = 5;
    _sendVerificationButton.layer.masksToBounds = YES;
    [_sendVerificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    _sendVerificationButton.backgroundColor = RGBColor(255, 192, 1);
    _sendVerificationButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_sendVerificationButton addTarget:self action:@selector(actionSendVerification:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendVerificationButton];
    [_sendVerificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_verificationTextField.mas_right);
        make.height.offset(30);
        make.top.equalTo(_verificationTextField.mas_top);
        make.right.equalTo(_accountTextField.mas_right);
    }];
    
    _resetButton = [[UIButton alloc] init];
    _resetButton.layer.cornerRadius = 5;
    _resetButton.layer.masksToBounds = YES;
    [_resetButton setTitle:@"重置密码" forState:UIControlStateNormal];
    _resetButton.backgroundColor = RGBColor(255, 192, 1);
    _resetButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_resetButton addTarget:self action:@selector(actionReset:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetButton];
    [_resetButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_accountTextField.mas_centerX);
        make.height.offset(30);
        make.top.equalTo(_verificationTextField.mas_bottom).offset(60);
        make.width.offset(kScreenWidth-80);
    }];
}

#pragma mark - action
- (void)actionBack:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSendVerification:(UIButton *)button {
    if (_accountTextField.text && _accountTextField.text.length) {
        [self requestVerification];
    }else {
        [self showErrorWithString:@"请输入正确的验证码"];
    }
}

- (void)actionReset:(UIButton *)button {
    [self setEditing:YES];
    NSArray *message = @[@"请输入账号", @"请输入密码", @"请重新输入密码", @"请输入验证码", @"验证码错误"];
    if (!_accountTextField.text || !_accountTextField.text.length) {
        [self showErrorWithString:message[0]];
    }else if (!_passwordTextField.text && !_passwordTextField.text.length) {
        [self showErrorWithString:message[1]];
    }else if (!_repeatPasswordTextField.text && !_repeatPasswordTextField.text.length) {
        [self showErrorWithString:message[2]];
    }else if (!_verificationTextField.text && _verificationTextField.text.length) {
        [self showErrorWithString:message[3]];
    }else if (!_verificationCode && ![_verificationCode isEqualToString:_verificationTextField.text]) {
        [self showErrorWithString:message[4]];
    }else {
        [self requestReset];
    }
}

- (BOOL)verification {
    if (!_accountTextField.text.length || !_passwordTextField.text.length || !_repeatPasswordTextField.text.length) {
        [self showErrorWithString:@"请输入正确的信息"];
        return NO;
    }
    if ([NSString isMobileNumber:_accountTextField.text]) {
        [self showErrorWithString:@"请输入正确的手机号"];
        return NO;
    }
    if ([NSString isValidatePwd:_passwordTextField.text]) {
        [self showErrorWithString:@"密码只能为6-12为数字或字母"];
        return NO;
    }
    if ([_repeatPasswordTextField.text isEqualToString:_passwordTextField.text]) {
        [self showErrorWithString:@"两次密码不一样，请重新输入"];
        return NO;
    }
    return YES;
}

#pragma mark - request
- (void)requestReset {
    if ([self verification]) {
        NSDictionary *parameters = @{@"account": _accountTextField.text, @"password": _passwordTextField.text};
        [[YWHttpManager shareInstance] requestResetPassword:parameters success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"重置成功，请重新登录"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } otherFailure:^(id responseObject) {
        } failure:^(NSError *error) {
        }];
    }
}

- (void)requestVerification {
    if (!_accountTextField.text.length) {
        [self showErrorWithString:@"请输入手机号"];
    }
    NSDictionary *parameters = @{@"account": _accountTextField.text};
    [self delayMethod];
    [[YWHttpManager shareInstance] requestVerification:parameters success:^(id responseObject) {
        _verificationCode = responseObject[@"verificationCode"];
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

- (void)delayMethod {
    static int cnt = 60;
    _sendVerificationButton.backgroundColor = [UIColor lightGrayColor];
    if (!cnt--) {
        _sendVerificationButton.userInteractionEnabled = YES;
        [_sendVerificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendVerificationButton.backgroundColor = [UIColor orangeColor];
        cnt = 60;
    }else {
        _sendVerificationButton.userInteractionEnabled = NO;
        [_sendVerificationButton setTitle:[NSString stringWithFormat:@"%ld s", (long)cnt] forState:UIControlStateNormal];
        [self performSelector:@selector(delayMethod) withObject:self afterDelay:1];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void)showErrorWithString:(NSString *)message {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alter animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
    }
}


@end
