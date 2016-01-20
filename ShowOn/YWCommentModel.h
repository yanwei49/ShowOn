//
//  YWCommentModel.h
//  ShowOn
//
//  Created by 颜魏 on 15/12/13.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kCommentMovieType,
    kCommentCommentType
} CommentType;

@class YWUserModel;
@class YWTrendsModel;
@interface YWCommentModel : NSObject

@property (nonatomic, strong) NSString    *commentsTargetId;    //被评论的目标ID
@property (nonatomic, strong) NSString    *commentId;           //评论的ID
@property (nonatomic, strong) NSString    *relationId;          //评论关联的另一方的ID
@property (nonatomic, strong) NSString    *isSupport;           //当前登录用户是否点赞 (0：否   1：是)
@property (nonatomic, strong) NSString    *commentTime;         //评论时间
@property (nonatomic, strong) NSString    *commentContent;      //评论内容
@property (nonatomic, assign) CommentType  commentType;         //评论的类型（1、动态,2、评论）
@property (nonatomic, strong) YWUserModel *commentUser;         //发布该评论的用户
@property (nonatomic, strong) YWUserModel *beCommentUser;       //被评论的用户
@property (nonatomic, strong) YWTrendsModel *commentTrends;     //评论的动态

@end
