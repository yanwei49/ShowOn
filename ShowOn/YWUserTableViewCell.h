//
//  YWUserTableViewCell.h
//  ShowOn
//
//  Created by David Yu on 17/2/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWUserModel;
@interface YWUserTableViewCell : UITableViewCell

@property (nonatomic, strong) YWUserModel *user;
@property (nonatomic, assign) BOOL state;

@end
