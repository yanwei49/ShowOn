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

-(id)init
{
    self =[super init];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
        //设置圆角
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;

    [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE)]];
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    self.conversationListTableView.backgroundColor = [UIColor whiteColor];
    self.isShowNetworkIndicatorView = NO;
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
