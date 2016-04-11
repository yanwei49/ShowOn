//
//  YWExperienceDetailViewController.m
//  ShowOn
//
//  Created by David Yu on 7/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWExperienceDetailViewController.h"

@implementation YWExperienceDetailViewController
{
    UIWebView          *_webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"经验值说明";
    
    [self createSubView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - subView
- (void)createSubView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"experience" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path?:@""];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
