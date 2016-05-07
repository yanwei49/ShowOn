//
//  YWCastingTableViewCell.h
//  ShowOn
//
//  Created by David Yu on 6/5/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWUserModel;
@protocol YWCastingTableViewCellDelegate <NSObject>

- (void)castingTableViewCellDidSelectPlayButton;
- (void)castingTableViewCellDidSelectRecorderButton;
- (void)castingTableViewCellDidSelectSupportButton;

@end
@interface YWCastingTableViewCell : UITableViewCell

@property (nonatomic, strong) YWUserModel *user;
@property (nonatomic, assign) id<YWCastingTableViewCellDelegate> delegate;

@end
