//
//  YWMouldModel.h
//  ShowOn
//
//  Created by David Yu on 13/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMouldModel : NSObject

@property (nonatomic, strong) NSString *mouldId;         //模板id
@property (nonatomic, strong) NSString *mouldName;       //模板名字
@property (nonatomic, strong) NSString *mouldTimeLength; //模板时间长度
@property (nonatomic, strong) NSString *mouldShootNums;  //模板被拍摄的次数
@property (nonatomic, strong) NSString *mouldCoverImage; //模板封面图片

@end
