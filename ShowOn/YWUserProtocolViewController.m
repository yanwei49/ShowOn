//
//  YWUserProtocolViewController.m
//  ShowOn
//
//  Created by David Yu on 17/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWUserProtocolViewController.h"

@interface YWUserProtocolViewController ()

@end

@implementation YWUserProtocolViewController
{
    UIWebView     *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    
    return;
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = Subject_color;
    [self.view addSubview:_webView];
    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(64);
        make.left.right.bottom.offset(0);
    }];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webView loadRequest:request];
}


@end
