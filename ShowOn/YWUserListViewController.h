//
//  YWUserListViewController.h
//  ShowOn
//
//  Created by David Yu on 17/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWBaseViewController.h"

@protocol YWUserListViewControllerDelegate <NSObject>

- (void)userListViewControllerDidSelectUsers:(NSArray *)users;

@end

@interface YWUserListViewController : YWBaseViewController

@property (nonatomic, strong) id<YWUserListViewControllerDelegate> delegate;

@end
