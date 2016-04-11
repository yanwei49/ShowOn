//
//  YWFollowingTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWUserModel;
@class YWFollowingTableViewCell;
@protocol YWFollowingTableViewCellDelegate <NSObject>

- (void)followingTableViewCellDidSelectButton:(YWFollowingTableViewCell *)cell;

@end

@interface YWFollowingTableViewCell : UITableViewCell

@property (nonatomic, strong) YWUserModel  *user;
@property (nonatomic, assign) BOOL relationButtonState;
@property (nonatomic, assign) id<YWFollowingTableViewCellDelegate> delegate;


@end
