//
//  YWMovieCardModel.h
//  ShowOn
//
//  Created by David Yu on 7/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMovieCardModel : NSObject

@property (nonatomic, strong) NSString *cardId;             //名片id
@property (nonatomic, strong) NSString *authentication;     //认证
@property (nonatomic, strong) NSString *address;            //地区
@property (nonatomic, strong) NSString *age;                //年龄
@property (nonatomic, strong) NSString *constellation;      //星座
@property (nonatomic, strong) NSString *height;             //身高
@property (nonatomic, strong) NSString *bwh;                //三围
@property (nonatomic, strong) NSString *announce;           //通告
@property (nonatomic, strong) NSString *email;              //邮箱
@property (nonatomic, strong) NSString *info;               //文字简介
@property (nonatomic, strong) NSArray *trends;              //视频所属动态
@property (nonatomic, strong) NSString *userId;             //名片所属用户id

@end
