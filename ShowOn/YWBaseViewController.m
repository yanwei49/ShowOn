//
//  YWBaseViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"
#import "YWLoginViewController.h"
#import "YWHttpManager.h"
#import "YWParser.h"

#import "YWMovieTemplateModel.h"

@interface YWBaseViewController ()

@end

@implementation YWBaseViewController
{
    NSMutableArray      *_templateArray;
    YWHttpManager       *_httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _templateArray = [[NSMutableArray alloc] init];
    _httpManager = [YWHttpManager shareInstance];
    
}

- (void)dataSource {
    for (NSInteger i=0; i<10; i++) {
        YWMovieTemplateModel *template = [[YWMovieTemplateModel alloc] init];
        template.templateId = [NSString stringWithFormat:@"%ld", i];
        template.templateName = [NSString stringWithFormat:@"模板%ld", i];
        template.templateVideoUrl = @"";
        template.templateVideoTime = @"1分20秒";
        template.templatePlayUserNumbers = @"12";
        template.templateVideoCoverImage = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
        template.templateTypeId = [NSString stringWithFormat:@"%ld", (long)arc4random()%3+1];

        [_templateArray addObject:template];
    }
}

- (void)createLeftItemWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 70, 34)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(actionLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)actionLeftItem:(UIButton *)button {

}

- (void)createRightItemWithTitle:(NSString *)title {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 5, 70, 34)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(actionRightItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)createRightItemWithImage:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 5, 70, 34)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionRightItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)actionRightItem:(UIButton *)button {

}

- (void)login {
    YWLoginViewController *loginVC = [[YWLoginViewController alloc] init];
    loginVC.backButtonHiddenState = NO;
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - request
- (void)requestTemplateList {
    [_httpManager requestTemplateList:nil success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        NSArray *array = [parser templateWithArray:responseObject[@"templateList"]];
        [_templateArray addObjectsFromArray:array];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
