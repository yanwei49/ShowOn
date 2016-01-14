//
//  YWMouldTypeModel.h
//  ShowOn
//
//  Created by David Yu on 14/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kMouldTypeWithPeople,          //名人专场
    kMouldTypeWithMovie,           //视频分类
    kMouldTypeWithAplication       //应用模板
} MouldType;
@interface YWMouldTypeModel : NSObject

@property (nonatomic, assign) MouldType  mouldType;            //类型（0.名人专场   1.视频分类   2.应用模板）
@property (nonatomic, strong) NSString  *mouldTypeId;          //id
@property (nonatomic, strong) NSString  *mouldTypeName;        //名字
@property (nonatomic, strong) NSString  *mouldTypeImageUrl;    //图片

@end
