//
//  YWPaser.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWParser.h"
#import "YWUserModel.h"
#import "YWMovieModel.h"
#import "YWCommentModel.h"
#import "YWArticleModel.h"
#import "YWMovieTemplateModel.h"
#import "YWSubsectionVideoModel.h"
#import "YWTrendsModel.h"

@implementation YWParser

- (YWUserModel *)userWithDict:(NSDictionary *)dict {
    YWUserModel *user = [[YWUserModel alloc] init];
    user.userId = [dict objectForKey:@"userId"];
    user.userType = [dict objectForKey:@"accountTypeId"];
    user.userAccount = [dict objectForKey:@"account"];
    user.userPassword = [dict objectForKey:@"password"];
    user.userToken = [dict objectForKey:@""];
    user.portraitUri = [dict objectForKey:@""];
    user.userEmpirical = [dict objectForKey:@""];
    user.userSex = [dict objectForKey:@"sex"];
    user.userName = [dict objectForKey:@"nickname"];
    user.userRank = [dict objectForKey:@"grade"];
    user.userBirthday = [dict objectForKey:@"birthday"];
    user.userBwh = [dict objectForKey:@"bwh"];
    user.userheight = [dict objectForKey:@"height"];
    user.userConstellation = [dict objectForKey:@"constellation"];
    user.userAuthentication = [dict objectForKey:@"authenticationInformation"];
    user.userInfos = [dict objectForKey:@"introduction"];
    user.userFocusNums = [dict objectForKey:@""];
    user.userTrendsNums = [dict objectForKey:@""];
    user.userFollowsNums = [dict objectForKey:@""];
    user.userCollectNums = [dict objectForKey:@""];
    user.userWorksNums = [dict objectForKey:@""];
    user.userDistrict = [dict objectForKey:@"district"];
    user.userRelationType = [[dict objectForKey:@"relationTypeId"] integerValue];
    
    return user;
}

- (YWMovieModel *)movieWithDict:(NSDictionary *)dict {
    YWMovieModel *movie = [[YWMovieModel alloc] init];
    
    
    return movie;
}

- (YWMovieTemplateModel *)templateWithDict:(NSDictionary *)dict {
    YWMovieTemplateModel *template = [[YWMovieTemplateModel alloc] init];
    template.templateId = [dict objectForKey:@""];
    template.templateName = [dict objectForKey:@""];
    template.templateVideoUrl = [dict objectForKey:@""];
    template.templateVideoTime = [dict objectForKey:@""];
    template.templateVideoCoverImage = [dict objectForKey:@""];
    template.templateTypeId = [dict objectForKey:@""];
    template.templatePlayUserNumbers = [dict objectForKey:@""];
    template.templatePlayUsers = [dict objectForKey:@""];
    template.templateSubsectionVideos = [dict objectForKey:@""];
    
    return template;
}

- (YWSubsectionVideoModel *)subsectionVideoWithDict:(NSDictionary *)dict {
    YWSubsectionVideoModel *subsectionVideo = [[YWSubsectionVideoModel alloc] init];
    subsectionVideo.subsectionVideoId = [dict objectForKey:@""];
    subsectionVideo.subsectionVideoUrl = [dict objectForKey:@""];
    subsectionVideo.subsectionVideoCoverImage = [dict objectForKey:@""];
    subsectionVideo.subsectionVideoSort = [dict objectForKey:@""];
    subsectionVideo.subsectionVideoType = [dict objectForKey:@""];
    subsectionVideo.subsectionVideoPerformanceStatus = [dict objectForKey:@""];
    subsectionVideo.subsectionVideoPlayUser = [dict objectForKey:@""];
    subsectionVideo.subsectionVideoTemplate = [dict objectForKey:@""];
    
    return subsectionVideo;
}

- (YWTrendsModel *)trendsWithDict:(NSDictionary *)dict {
    YWTrendsModel *trends = [[YWTrendsModel alloc] init];
    trends.trendsId = [dict objectForKey:@"dynamicId"];
    trends.trendsUser = [self userWithDict:[dict objectForKey:@"user"]];
    trends.trendsId = [dict objectForKey:@"dynamicContent"];
    trends.trendsId = [dict objectForKey:@""];
    trends.trendsId = [dict objectForKey:@""];
    trends.trendsId = [dict objectForKey:@""];
    trends.trendsId = [dict objectForKey:@""];
    trends.trendsId = [dict objectForKey:@""];
    trends.trendsId = [dict objectForKey:@""];
    trends.trendsId = [dict objectForKey:@""];
    trends.trendsId = [dict objectForKey:@""];
    
    return trends;
}

- (YWCommentModel *)commentWithDict:(NSDictionary *)dict {
    YWCommentModel *comment = [[YWCommentModel alloc] init];
    comment.commentUser = [self userWithDict:[dict objectForKey:@"user"]];
    comment.beCommentUser = [self userWithDict:[dict objectForKey:@"beCommentUser"]];
    comment.commentType = [[dict objectForKey:@"commentsTypeId"] integerValue];
    comment.commentId = [dict objectForKey:@"commentsId"];
    comment.relationId = [dict objectForKey:@"user"];
    comment.isSupport = [dict objectForKey:@"user"];
    comment.commentTime = [dict objectForKey:@"editTime"];
    comment.commentContent = [dict objectForKey:@"commentsContent"];
    
    return comment;
}

- (YWArticleModel *)articleWithDict:(NSDictionary *)dict {
    YWArticleModel *article = [[YWArticleModel alloc] init];
    article.articleId = [dict objectForKey:@"teletextId"];
    article.articleTitle = [dict objectForKey:@"title"];
    article.articleAuthorName = [dict objectForKey:@"author"];
    article.articleCoverImage = [dict objectForKey:@""];
    article.articleTime = [dict objectForKey:@"pubdate"];
    article.articleUrl = [dict objectForKey:@""];             
    
    return article;
}



@end
