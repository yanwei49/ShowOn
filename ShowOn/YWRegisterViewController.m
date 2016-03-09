//
//  YWRegisterViewController.m
//  ShowOn
//
//  Created by David Yu on 5/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWRegisterViewController.h"
#import "NSString+isValidate.h"
#import "YWHttpManager.h"

@interface YWRegisterViewController ()<UITextFieldDelegate>

@end

@implementation YWRegisterViewController
{
    UITextField    *_accountTextField;
    UITextField    *_passwordTextField;
    UITextField    *_repeatPasswordTextField;
    UITextField    *_verificationTextField;
    UIButton       *_sendVerificationButton;
    UIButton       *_registerButton;
    NSString       *_verificationCode;
    NSInteger       _timeCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"注册角儿JUER账号";
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
    _passwordTextField.placeholder = @" 请输入6-12位数字或字母密码";
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountTextField.mas_bottom).offset(5);
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
        make.top.equalTo(_passwordTextField.mas_bottom).offset(5);
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
        make.top.equalTo(_repeatPasswordTextField.mas_bottom).offset(5);
        make.left.equalTo(_repeatPasswordTextField.mas_left);
        make.height.offset(30);
        make.width.offset(kScreenWidth-180);
    }];
    
    _sendVerificationButton = [[UIButton alloc] init];
    _sendVerificationButton.layer.cornerRadius = 5;
    _sendVerificationButton.layer.masksToBounds = YES;
    [_sendVerificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    _sendVerificationButton.backgroundColor = [UIColor orangeColor];
    _sendVerificationButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_sendVerificationButton addTarget:self action:@selector(actionSendVerification:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendVerificationButton];
    [_sendVerificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_verificationTextField.mas_right);
        make.height.offset(30);
        make.top.equalTo(_verificationTextField.mas_top);
        make.right.equalTo(_accountTextField.mas_right);
    }];
    
    _registerButton = [[UIButton alloc] init];
    _registerButton.layer.cornerRadius = 5;
    _registerButton.layer.masksToBounds = YES;
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    _registerButton.backgroundColor = [UIColor orangeColor];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_registerButton addTarget:self action:@selector(actionRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    [_registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_accountTextField.mas_centerX);
        make.height.offset(30);
        make.top.equalTo(_verificationTextField.mas_bottom).offset(40);
        make.width.offset(80);
    }];
}

#pragma mark - action
- (void)actionBack:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSendVerification:(UIButton *)button {
    _timeCount = 60;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (_accountTextField.text && _accountTextField.text.length) {
        [self requestVerification];
    }else {
        [self showErrorWithString:@"请输入登录账号"];
    }
}

- (void)actionRegister:(UIButton *)button {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
        if ([self verification]) {
            [self requestRegister];
        }
    }
}

- (BOOL)verification {
    if (![NSString isMobileNumber:_accountTextField.text]) {
        [self showErrorWithString:@"请输入正确的手机号"];
        return NO;
    }
    if (![NSString isValidatePwd:_passwordTextField.text]) {
        [self showErrorWithString:@"密码只能为6-12为数字或字母"];
        return NO;
    }
    if (![_repeatPasswordTextField.text isEqualToString:_passwordTextField.text]) {
        [self showErrorWithString:@"两次密码不一样，请重新输入"];
        return NO;
    }
    return YES;
}

#pragma mark - request
- (void)requestVerification {
    NSDictionary *parameters = @{@"account": _accountTextField.text};
    [self delayMethod];
    [[YWHttpManager shareInstance] requestVerification:parameters success:^(id responseObject) {
        _verificationCode = responseObject[@"verificationCode"];
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

- (void)delayMethod {
    _sendVerificationButton.backgroundColor = [UIColor lightGrayColor];
    if (!_timeCount--) {
        _sendVerificationButton.userInteractionEnabled = YES;
        [_sendVerificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendVerificationButton.backgroundColor = [UIColor orangeColor];
        _timeCount = 60;
    }else {
        _sendVerificationButton.userInteractionEnabled = NO;
        [_sendVerificationButton setTitle:[NSString stringWithFormat:@"%ld s", (long)_timeCount] forState:UIControlStateNormal];
        [self performSelector:@selector(delayMethod) withObject:self afterDelay:1];
    }
}

- (void)requestRegister {
    NSDictionary *parameters = @{@"account": _accountTextField.text, @"password": _passwordTextField.text, @"accountTypeId": @(1), @"nickname": @"", @"birthday": @"", @"sex": @"", @"introduction": @""};
    [[YWHttpManager shareInstance] requestRegister:parameters success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        [self registerSuccess];
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

- (void)registerSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccess object:nil];
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
