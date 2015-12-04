//
//  YWMessageViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWMessageViewController.h"
#import "YWChatRoomViewComtroller.h"

@implementation YWMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];

    [self createBackLeftItem];
}

- (void)createBackLeftItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 70, 34)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor =[UIColor lightGrayColor].CGColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)actionBack:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    YWChatRoomViewComtroller *vc = [[YWChatRoomViewComtroller alloc] init];
    [self.conversationListTableView deselectRowAtIndexPath:indexPath animated:YES];
    vc.conversationType = model.conversationType;
    vc.targetId = model.targetId;
    vc.userName = model.conversationTitle;
    vc.title = model.conversationTitle;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
