//
//  YWATMeTableViewCell.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YWAiTeModel;
@class YWATMeTableViewCell;
@protocol YWATMeTableViewCellDelegate <NSObject>

- (void)aTMeTableViewCellDidSelectPlay:(YWATMeTableViewCell *)cell;

@end
@interface YWATMeTableViewCell : UITableViewCell

@property (nonatomic, strong) YWAiTeModel *aiTe;
@property (nonatomic, strong) id<YWATMeTableViewCellDelegate> delegate;

@end
