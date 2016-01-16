//
//  YWArticleDetailViewController.m
//  ShowOn
//
//  Created by David Yu on 16/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWArticleDetailViewController.h"
#import "YWArticleModel.h"

@interface YWArticleDetailViewController ()

@end

@implementation YWArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = _article.articleTitle;

    UIWebView *web = [[UIWebView alloc] init];
    web.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:web];
    [web  makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [web loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_article.articleUrl]]];
}



@end
