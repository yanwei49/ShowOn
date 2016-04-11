//
//  YWPaser.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWMovieTemplateModel;
@class YWTrendsModel;
@class YWUserModel;

@interface YWParser : NSObject

//解析模板列表数据
- (NSArray *)templateWithArray:(NSArray *)array;

//解析模板详情数据
- (YWMovieTemplateModel *)templateWithDict:(NSDictionary *)dict;

//解析动态列表
- (NSArray *)trendsWithArray:(NSArray *)array;

//解析动态详情
- (YWTrendsModel *)trendsWithDict:(NSDictionary *)dict;

//解析评论列表
- (NSArray *)commentsWithArray:(NSArray *)array;

//解析图文列表
- (NSArray *)articleWithArray:(NSArray *)array;

//解析用户数据
- (YWUserModel *)userWithDict:(NSDictionary *)dict;

//解析用户列表
- (NSArray *)userWithArray:(NSArray *)array;

//解析@我列表
- (NSArray *)aiTeWithArray:(NSArray *)array;

//解析点赞列表
- (NSArray *)supportWithArray:(NSArray *)array;

//解析视频名片列表
- (NSArray *)movieCardWithArray:(NSArray *)array;

@end
