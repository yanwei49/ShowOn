//
//  YWLoginViewController.m
//  ShowOn
//
//  Created by David Yu on 5/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWLoginViewController.h"
#import "YWRegisterViewController.h"
#import "YWForgetPasswordViewController.h"
#import "NSString+isValidate.h"

static NSString *LoginSuccess = @"Login_success";
@interface YWLoginViewController ()<UITextFieldDelegate>

@end

@implementation YWLoginViewController
{
    UITextField    *_accountTextField;
    UITextField    *_passwordTextField;
    UIButton       *_loginButton;
    UIButton       *_registerButton;
    UIButton       *_forgetPasswordButton;
    UIView         *_otherLoginMethodBackgroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSubViews];
}

- (void)createSubViews {
    _accountTextField = [[UITextField alloc] init];
    _accountTextField.delegate = self;
    _accountTextField.backgroundColor = [UIColor whiteColor];
    _accountTextField.layer.cornerRadius = 5;
    _accountTextField.layer.masksToBounds = YES;
    _accountTextField.layer.borderWidth = 1;
    _accountTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _accountTextField.placeholder = @" 手机号";
    _accountTextField.font = [UIFont systemFontOfSize:16];
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_accountTextField];
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(30);
        make.width.offset(kScreenWidth-80);
    }];
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.delegate = self;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.layer.cornerRadius = 5;
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.borderWidth = 1;
    _passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _passwordTextField.placeholder = @" 请输入6-12位数字或字母密码";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountTextField.mas_bottom).offset(5);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(30);
        make.width.offset(kScreenWidth-80);
    }];

    _loginButton = [[UIButton alloc] init];
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.backgroundColor = [UIColor orangeColor];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_loginButton addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    [_loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_accountTextField.mas_centerX);
        make.height.offset(30);
        make.top.equalTo(_passwordTextField.mas_bottom).offset(10);
        make.width.offset(80);
    }];

    _registerButton = [[UIButton alloc] init];
    _registerButton.backgroundColor = [UIColor whiteColor];
    [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_registerButton addTarget:self action:@selector(actionRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    [_registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_accountTextField.mas_left).offset(10);
        make.height.offset(20);
        make.top.equalTo(_loginButton.mas_bottom).offset(10);
    }];
    
    _forgetPasswordButton = [[UIButton alloc] init];
    _forgetPasswordButton.backgroundColor = [UIColor whiteColor];
    [_forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgetPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_forgetPasswordButton addTarget:self action:@selector(actionForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPasswordButton];
    [_forgetPasswordButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_accountTextField.mas_right).offset(-10);
        make.height.offset(20);
        make.top.equalTo(_loginButton.mas_bottom).offset(10);
    }];
    
    _otherLoginMethodBackgroundView = [[UIView alloc] init];
    _otherLoginMethodBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_otherLoginMethodBackgroundView];
    [_otherLoginMethodBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-40);
        make.left.right.offset(0);
        make.height.offset(80);
    }];
    
    NSArray *titles = @[@"微信登录", @"QQ登录", @"微博登录"];
    for (NSInteger i=0; i<3; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 100+i;
        [button addTarget:self action:@selector(actionOtherLoginMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_otherLoginMethodBackgroundView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.offset(0);
            make.centerY.equalTo(_otherLoginMethodBackgroundView.mas_centerY);
            make.width.offset(60);
            i==1?make.centerX.equalTo(_otherLoginMethodBackgroundView.mas_centerX):nil;
            i==0?make.right.equalTo(_otherLoginMethodBackgroundView.mas_centerX).offset(-70):nil;
            i==2?make.left.equalTo(_otherLoginMethodBackgroundView.mas_centerX).offset(70):nil;
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor greenColor];
        imageView.image = [UIImage imageNamed:@""];
        [button addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.offset(-20);
        }];
        
        UILabel *label =[[UILabel alloc] init];
        label.backgroundColor = [UIColor whiteColor];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [button addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(20);
        }];
    }
    
    UILabel  *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:25];
    label.text = @"我就是角儿!";
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY).offset(-40);
        make.height.offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.offset(200);
        make.height.offset(100);
    }];
    
    UILabel  *label1 = [[UILabel alloc] init];
    label1.backgroundColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:30];
    label1.text = @"角儿 JUER";
    [self.view addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.height.offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - action
- (void)actionLogin:(UIButton *)button {
    
}

- (void)actionRegister:(UIButton *)button {
    YWRegisterViewController *vc = [[YWRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionForgetPassword:(UIButton *)button {
    YWForgetPasswordViewController *vc = [[YWForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionOtherLoginMethod:(UIButton *)button {
    switch (button.tag-100) {
        case 0:
            [self weixinLogin];
            break;
        case 1:
            [self qqLogin];
            break;
        case 2:
            [self weiboLogin];
            break;
        default:
            break;
    }
}

- (void)weixinLogin {
    
}

- (void)qqLogin {
    
}

- (void)weiboLogin {
    
}

- (void)loginSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccess object:nil];
}

#pragma mark - request
- (void)requestLoginWithType {

}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text) {
        if ([textField isEqual:_accountTextField]) {
            if ([NSString isMobileNumber:_accountTextField.text]) {
                [_accountTextField resignFirstResponder];
                [_passwordTextField becomeFirstResponder];
            }else {
                [self showErrorWithString:@"请输入正确的手机号"];
            }
        }else {
            if ([NSString isValidatePwd:_passwordTextField.text]) {
                [_passwordTextField resignFirstResponder];
            }else {
                [self showErrorWithString:@"密码只能为6-12为数字或字母"];
            }
        }
    }else {
        NSArray *tfs = @[_accountTextField, _passwordTextField];
        NSArray *message = @[@"请输入账号", @"请输入密码"];
        NSInteger index = [tfs indexOfObject:textField];
        [self showErrorWithString:message[index]];
    }
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