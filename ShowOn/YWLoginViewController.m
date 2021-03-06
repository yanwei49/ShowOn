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
#import "YWHttpManager.h"
#import "UMSocial.h"
#import "UMSocialSnsPlatformManager.h"
#import "YWUserModel.h"
#import "YWParser.h"
#import "YWDataBaseManager.h"
#import "YWFriendListManager.h"
#import <RongIMKit/RongIMKit.h>
//#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

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
    YWUserModel    *_othersUser;
    UIButton       *_backButton;
    NSInteger       _loginType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    _othersUser = [[YWUserModel alloc] init];
    
    [self createSubViews];
}

-(void)dealloc {
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)createSubViews {
    _backButton = [[UIButton alloc] init];
    _backButton.backgroundColor = Subject_color;
    [_backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    _backButton.hidden = _backButtonHiddenState;
    [self.view addSubview:_backButton];
    [_backButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(20);
        make.width.height.offset(30);
    }];
    
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
        make.top.equalTo(self.view.mas_centerY).offset(Is480Height?-50:-30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(35);
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
        make.top.equalTo(_accountTextField.mas_bottom).offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(35);
        make.width.offset(kScreenWidth-80);
    }];

    _loginButton = [[UIButton alloc] init];
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.backgroundColor = RGBColor(255, 192, 1);
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_loginButton addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    [_loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_accountTextField.mas_centerX);
        make.height.offset(35);
        make.top.equalTo(_passwordTextField.mas_bottom).offset(10);
        make.width.offset(kScreenWidth-80);
    }];

    _registerButton = [[UIButton alloc] init];
    _registerButton.backgroundColor = Subject_color;
    [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_registerButton addTarget:self action:@selector(actionRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    [_registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_accountTextField.mas_left).offset(10);
        make.height.offset(20);
        make.top.equalTo(_loginButton.mas_bottom).offset(10);
    }];
    
    _forgetPasswordButton = [[UIButton alloc] init];
    _forgetPasswordButton.backgroundColor = Subject_color;
    [_forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_forgetPasswordButton addTarget:self action:@selector(actionForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetPasswordButton];
    [_forgetPasswordButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_accountTextField.mas_right).offset(-10);
        make.height.offset(20);
        make.top.equalTo(_loginButton.mas_bottom).offset(10);
    }];
    
    _otherLoginMethodBackgroundView = [[UIView alloc] init];
    _otherLoginMethodBackgroundView.backgroundColor = Subject_color;
    [self.view addSubview:_otherLoginMethodBackgroundView];
    [_otherLoginMethodBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(Is480Height?-20:-40);
        make.left.right.offset(0);
        make.height.offset(80);
    }];
    
    NSArray *titles;
    NSArray *imageNames;
    if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
        titles = @[@"微信登录", @"QQ登录", @"微博登录"];
        imageNames= @[@"wechat.png", @"qq.png", @"weibo.png"];
    }else if ([QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
        titles = @[@"QQ登录", @"微博登录"];
        imageNames= @[@"qq.png", @"weibo.png"];
    }else if (![QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
        titles = @[@"微信登录", @"微博登录"];
        imageNames= @[@"wechat.png", @"weibo.png"];
    }else if (![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
        titles = @[@"微博登录"];
        imageNames= @[@"weibo.png"];
    }
    for (NSInteger i=0; i<titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = Subject_color;
        button.tag = 100+i;
        [button addTarget:self action:@selector(actionOtherLoginMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_otherLoginMethodBackgroundView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.offset(0);
            make.centerY.equalTo(_otherLoginMethodBackgroundView.mas_centerY);
            make.width.offset(60);
            if (titles.count==1) {
                make.centerX.equalTo(_otherLoginMethodBackgroundView.mas_centerX);
            }else if (titles.count==2) {
                i==0?make.centerX.equalTo(_otherLoginMethodBackgroundView.mas_centerX).offset(-40):nil;
                i==1?make.centerX.equalTo(_otherLoginMethodBackgroundView.mas_centerX).offset(40):nil;
            }else {
                i==0?make.centerX.equalTo(_otherLoginMethodBackgroundView.mas_centerX).offset(-80):nil;
                i==1?make.centerX.equalTo(_otherLoginMethodBackgroundView.mas_centerX):nil;
                i==2?make.centerX.equalTo(_otherLoginMethodBackgroundView.mas_centerX).offset(80):nil;
            }
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = Subject_color;
        imageView.image = [UIImage imageNamed:imageNames[i]];
        [button addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.offset(0);
            make.bottom.offset(-20);
        }];
        
        UILabel *label =[[UILabel alloc] init];
        label.backgroundColor = Subject_color;
        label.textColor = [UIColor whiteColor];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [button addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(20);
        }];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = Subject_color;
    imageView.image = [UIImage imageNamed:@"juer.png"];
    [self.view addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(Is480Height?60:90);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.offset(200);
        make.height.offset(Is480Height?80:100);
    }];
}

#pragma mark - action
- (void)actionBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionLogin:(UIButton *)button {
    _loginType = 1;
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    if (_accountTextField.text.length && _passwordTextField.text.length) {
        if (![NSString isMobileNumber:_accountTextField.text]) {
            [self showErrorWithString:@"请输入正确的手机号"];
            return;
        }
        if (![NSString isValidatePwd:_passwordTextField.text]) {
            [self showErrorWithString:@"密码只能为6-12为数字或字母"];
            return;
        }
        [self requestLogin];
    }else {
        [self showErrorWithString:@"请输入账号和密码"];
    }
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
    if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
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
    }else if ([QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
        switch (button.tag-100) {
            case 0:
                [self qqLogin];
                break;
            case 1:
                [self weiboLogin];
                break;
            default:
                break;
        }
    }else if (![QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
        switch (button.tag-100) {
            case 0:
                [self weixinLogin];
                break;
            case 1:
                [self weiboLogin];
                break;
            default:
                break;
        }
    }else if (![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
        switch (button.tag-100) {
            case 0:
                [self weiboLogin];
                break;
            default:
                break;
        }
    }
}

- (void)weixinLogin {
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        //        NSLog(@"SnsInformation is %@",response.data);
    }];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
            //            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            _othersUser.userName = snsAccount.userName;
            _othersUser.portraitUri = snsAccount.iconURL;
            _othersUser.userId = snsAccount.usid;
            _loginType = 3;
            
            [self requestRegister];
        }
        
    });
}

- (void)weiboLogin
{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
//            NSDictionary *_socialDict = [accountResponse.data objectForKey:@"accounts"];
//            _othersUser.userId = [[_socialDict objectForKey:@"sina"] objectForKey:@"usid"];
//            if (_othersUser.userId) {
//                _othersUser.userSex = [[_socialDict objectForKey:@"sina"] objectForKey:@"gender"];
//                _othersUser.userId = [[_socialDict objectForKey:@"sina"] objectForKey:@"usid"];
//                _othersUser.userName = [[_socialDict objectForKey:@"sina"] objectForKey:@"username"];
//                _othersUser.portraitUri = [[_socialDict objectForKey:@"sina"] objectForKey:@"icon"];
//                [[NSUserDefaults standardUserDefaults] setObject:[[_socialDict objectForKey:@"sina"] objectForKey:@"accessToken"] forKey:@"accessToken"];
//                _loginType = 4;
//                [self requestRegister];
//            }
//        }];
//    });
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            _othersUser.userId = snsAccount.usid;
//            _othersUser.userSex = snsAccount.gender;
            _othersUser.userName = snsAccount.userName;
            _othersUser.portraitUri = snsAccount.iconURL;
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.accessToken forKey:@"accessToken"];
            _loginType = 4;
            
            [self requestRegister];
        }
    });
}

- (void)qqLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
            NSDictionary *_socialDict = [accountResponse.data objectForKey:@"accounts"];
            _othersUser.userId = [[_socialDict objectForKey:@"qq"] objectForKey:@"openid"];
            if (_othersUser.userId) {
                _othersUser.userName = [[_socialDict objectForKey:@"qq"] objectForKey:@"username"];
                if ([[[_socialDict objectForKey:@"qq"] objectForKey:@"gender"] isEqualToString:NSLocalizedString(@"male", nil)]) {
                    _othersUser.userSex = @"1";
                }else {
                    _othersUser.userSex = @"0";
                }
                _othersUser.portraitUri = [[_socialDict objectForKey:@"qq"] objectForKey:@"icon"];
                
                _loginType = 2;
                [self requestRegister];
            }
        }];
    });
//    //设置回调对象
//    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
}


- (void)loginSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccess object:nil];
}

- (BOOL)verification {
    if (!_accountTextField.text.length || !_passwordTextField.text.length) {
        [self showErrorWithString:@"请输入账号和密码"];
        return NO;
    }
    if (![NSString isMobileNumber:_accountTextField.text]) {
        [self showErrorWithString:@"请输入正确的手机号"];
        return NO;
    }
    if (![NSString isValidatePwd:_passwordTextField.text]) {
        [self showErrorWithString:@"密码只能为6-12为数字或字母"];
        return NO;
    }
    return YES;
}

#pragma mark - request
- (void)requestLogin {
    if (![self verification]) {
        return;
    }
    NSDictionary *parameters = @{@"account":_accountTextField.text, @"password":_passwordTextField.text, @"type": @(1)};
    [SVProgressHUD showWithStatus:@"登录中..."];
    [[YWHttpManager shareInstance] requestLogin:parameters success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        YWParser *parser = [[YWParser alloc] init];
        _othersUser = [parser userWithDict:responseObject[@"user"]];
        [[YWDataBaseManager shareInstance] addLoginUser:_othersUser];
        [self loginSuccess];
        [YWFriendListManager shareInstance];
        [self connectRongYunSevers:_othersUser];
    } otherFailure:^(id responseObject) {
        [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (void)requestRegister {
    NSDictionary *parameters = @{@"account": _othersUser.userId?:@"", @"password": @"", @"accountTypeId": @(2), @"nickname": _othersUser.userName?:@"", @"birthday": _othersUser.userBirthday?:@"", @"sex": _othersUser.userSex?:@"", _othersUser.userInfos?:@"introduction": @""};
    [[YWHttpManager shareInstance] requestRegister:parameters success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        _othersUser = [parser userWithDict:responseObject[@"user"]];
        [[YWDataBaseManager shareInstance] addLoginUser:_othersUser];
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [self loginSuccess];
        [YWFriendListManager shareInstance];
        [self connectRongYunSevers:_othersUser];
    } otherFailure:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
}

- (void)connectRongYunSevers:(YWUserModel *)loginUser {
    [[RCIM sharedRCIM] connectWithToken:loginUser.userToken success:^(NSString *userId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DebugLog(@"连接融云成功");
        });
    } error:^(RCConnectErrorCode status) {
        DebugLog(@"连接失败");
    } tokenIncorrect:^{
        DebugLog(@"连接失败");
        if (_loginType != 1) {
            [self requestRegister];
        }else {
            [self requestLogin];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
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
