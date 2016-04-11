//
//  YWUserProtocolViewController.m
//  ShowOn
//
//  Created by David Yu on 17/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWUserProtocolViewController.h"
#import "YWHttpGlobalDefine.h"

@interface YWUserProtocolViewController ()

@end

@implementation YWUserProtocolViewController
{
    UIWebView     *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"用户协议";
    
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = Subject_color;
    [self.view addSubview:_webView];
    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:HOST_URL(User_Protocol_Method)]] ;
    [_webView loadRequest:request];
}


@end
