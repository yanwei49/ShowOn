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
#import "YWAiTeModel.h"
#import "YWSupportModel.h"
#import "YWMovieCardModel.h"

@implementation YWParser

- (YWUserModel *)userWithDict:(NSDictionary *)dict {
    YWUserModel *user = [[YWUserModel alloc] init];
    user.userId = [dict objectForKey:@"userId"];
    user.userType = [dict objectForKey:@"accountTypeId"];
    user.userAccount = [dict objectForKey:@"account"];
    user.userPassword = [dict objectForKey:@"password"];
    user.userToken = [dict objectForKey:@"token"];
    user.portraitUri = [dict objectForKey:@"headPortrait"];
    user.userEmpirical = [[dict objectForKey:@"empiricalValue"] length]?[dict objectForKey:@"empiricalValue"]:@"0";
    user.userSex = [dict objectForKey:@"sex"];
    user.userName = [dict objectForKey:@"nickname"];
    user.userRank = [dict objectForKey:@"grade"];
    user.userBirthday = [dict objectForKey:@"birthday"];
    user.userBwh = [dict objectForKey:@"bwh"];
    user.userheight = [dict objectForKey:@"height"];
    user.userConstellation = [dict objectForKey:@"constellation"];
    user.userAuthentication = [dict objectForKey:@"authenticationInformation"];
    user.userInfos = [dict objectForKey:@"introduction"];
    user.userFocusNums = [dict objectForKey:@"userFocusNums"]?:@"";
    user.userTrendsNums = [dict objectForKey:@"userTrendsNums"]?:@"";
    user.userFollowsNums = [dict objectForKey:@"userFocusNums"]?:@"";
    user.userCollectNums = [dict objectForKey:@"userCollectNums"]?:@"";
    user.userATMeNums = [dict objectForKey:@"userATMeNums"]?:@"";
    user.userCommentNums = [dict objectForKey:@"userCommentNums"]?:@"";
    user.userSupportNums = [dict objectForKey:@"userSupportNums"]?:@"";
    user.userDistrict = [dict objectForKey:@"district"];
    user.casting = [self movieWithDict:[dict objectForKey:@"casting"]];
    user.userTrends = [self trendsWithArray:[dict objectForKey:@"userTrends"]];
    user.userRelationType = [[dict objectForKey:@"relationTypeId"] integerValue];
    
    return user;
}

- (YWMovieModel *)movieWithDict:(NSDictionary *)dict {
    YWMovieModel *movie = [[YWMovieModel alloc] init];
    movie.movieId = [dict objectForKey:@"movieId"];
    movie.movieUrl = [dict objectForKey:@"videoUrl"];
    movie.movieIsSupport = [dict objectForKey:@"movieIsSupport"];
    movie.movieSupports = [dict objectForKey:@"movieSupports"];
    movie.movieName = [dict objectForKey:@"videoName"];
    movie.movieCoverImage = [dict objectForKey:@"videoCoverImage"];
    movie.movieTemplate = [self templateWithDict:[dict objectForKey:@"videoTemplate"]];
    if (!movie.movieName) {
        movie.movieName = [dict objectForKey:@"movieName"];
    }
    if (!movie.movieUrl) {
        movie.movieUrl = [dict objectForKey:@"movieUrl"];
    }
    if (!movie.movieCoverImage) {
        movie.movieCoverImage = [dict objectForKey:@"movieCoverImage"];
    }
    
    return movie;
}

- (YWMovieTemplateModel *)templateWithDict:(NSDictionary *)dict {
    YWMovieTemplateModel *template = [[YWMovieTemplateModel alloc] init];
    template.templateId = [dict objectForKey:@"templateId"];
    template.templateName = [dict objectForKey:@"templateName"];
    template.templateVideoUrl = [dict objectForKey:@"videoUrl"];
    template.templateVideoTime = [dict objectForKey:@"dateTimeOriginal"];
    template.templateVideoCoverImage = [dict objectForKey:@"templateCoverImage"];
    template.templateTypeId = [dict objectForKey:@"templateTypeId"];
    template.templateSubTypeId = [dict objectForKey:@"templateSubTypeId"];
    template.templatePlayUserNumbers = [dict objectForKey:@"shootTime"];
    template.templatePlayUsers = [self userWithArray:[dict objectForKey:@"templatePlayUsers"]];
    template.templateSubsectionVideos = [self subsectionVideoWithArray:[dict objectForKey:@"templateSubsectionVideos"]];
    template.templateTrends = [self trendsWithArray:[dict objectForKey:@"recordeRanklist"]];
    template.templateComments = [self commentsWithArray:[dict objectForKey:@"commentList"]];
    
    return template;
}

- (YWSubsectionVideoModel *)subsectionVideoWithDict:(NSDictionary *)dict {
    YWSubsectionVideoModel *subsectionVideo = [[YWSubsectionVideoModel alloc] init];
    subsectionVideo.subsectionVideoId = [dict objectForKey:@"subsectionVideoId"];
    subsectionVideo.subsectionVideoUrl = [dict objectForKey:@"videoUrl"];
    subsectionVideo.subsectionVideoCoverImage = [dict objectForKey:@""];
    subsectionVideo.subsectionVideoSort = [dict objectForKey:@"sort"];
    subsectionVideo.subsectionVideoType = [dict objectForKey:@"subsectionVideoTypeId"];
    subsectionVideo.subsectionVideoPerformanceStatus = [dict objectForKey:@"performanceStatusId"];
    subsectionVideo.subSort = [dict objectForKey:@"subSort"];
    subsectionVideo.subsectionVideoPlayUserId = [dict objectForKey:@"userId"];
    subsectionVideo.subsectionVideoTemplateId = [dict objectForKey:@"templateId"];
    subsectionVideo.subsectionVideoTime = [dict objectForKey:@"timeLength"];
    subsectionVideo.subsectionAudioUrl = [dict objectForKey:@"subsectionAudioUrl"];
    subsectionVideo.subsectionRecorderVideoUrl = [dict objectForKey:@"subsectionVideoUrl"];
    if (subsectionVideo.subsectionRecorderVideoUrl.length) {
        subsectionVideo.subsectionVideoPerformanceStatus = @"1";
    }
    
    return subsectionVideo;
}

- (YWTrendsModel *)trendsWithDict:(NSDictionary *)dict {
    YWTrendsModel *trends = [[YWTrendsModel alloc] init];
    trends.trendsId = [dict objectForKey:@"dynamicId"];
    trends.trendsUser = [self userWithDict:[dict objectForKey:@"user"]];
    trends.trendsType = [dict objectForKey:@"dynamicTypeId"];
    trends.trendsPubdate = [dict objectForKey:@"pubdate"];
    trends.trendsSuppotNumbers = [dict objectForKey:@"dynamicSuppotNumbers"];
    trends.trendsCollectionNumbers = [dict objectForKey:@"dynamicCollectionNumbers"];
    trends.trendsIsSupport = [dict objectForKey:@"dynamicIsSupport"];
    trends.trendsIsCollect = [dict objectForKey:@"dynamicIsCollect"];
    trends.trendsComments = [self commentsWithArray:[dict objectForKey:@"commentList"]];
    trends.trendsMovieCooperateUsers = [self userWithArray:[dict objectForKey:@"trendsMovieCooperateUsers"]];
    trends.trendsSubsectionVideos = [self subsectionVideoWithArray:[dict objectForKey:@"trendsSubsectionVideos"]];
    trends.trendsOtherPlayUsers = [self userWithArray:[dict objectForKey:@"trendsOtherPlayUsers"]];
    trends.trendsMovie = [self movieWithDict:[dict objectForKey:@"dynamicVideo"]];
    trends.trendsContent = [dict objectForKey:@"dynamicContent"];
    trends.trendsMoviePlayCount = [dict objectForKey:@"playCount"];
    trends.trendsForwardComments = [dict objectForKey:@"forwardComments"];

    return trends;
}

- (YWCommentModel *)commentWithDict:(NSDictionary *)dict {
    YWCommentModel *comment = [[YWCommentModel alloc] init];
    comment.commentUser = [self userWithDict:[dict objectForKey:@"user"]];
    comment.beCommentUser = [self userWithDict:[dict objectForKey:@"commentsTargetUser"]];
    comment.commentType = [[dict objectForKey:@"commentsTypeId"] integerValue];
    comment.commentId = [dict objectForKey:@"commentsId"];
    comment.isSupport = [dict objectForKey:@"isSupport"];
    comment.commentTime = [dict objectForKey:@"editTime"];
    comment.commentContent = [dict objectForKey:@"commentsContent"];
    comment.commentsTargetId = [dict objectForKey:@"commentsTargetId"];
    comment.commentTrends = [self trendsWithDict:[dict objectForKey:@"trends"]];
    comment.commentTemplate = [self templateWithDict:[dict objectForKey:@"template"]];
    
    return comment;
}

- (YWArticleModel *)articleWithDict:(NSDictionary *)dict {
    YWArticleModel *article = [[YWArticleModel alloc] init];
    article.articleId = [dict objectForKey:@"teletextId"];
    article.articleTitle = [dict objectForKey:@"title"];
    article.articleAuthorName = [dict objectForKey:@"author"];
    article.articleCoverImage = [dict objectForKey:@"coverImage"];
    article.articleTime = [dict objectForKey:@"pubdate"];
    article.articleUrl = [dict objectForKey:@""];
    
    return article;
}

- (YWAiTeModel *)aiTesWithDict:(NSDictionary *)dict {
    YWAiTeModel *aite = [[YWAiTeModel alloc] init];
    aite.aiTeType = [dict objectForKey:@"teletextId"];
    aite.trends = [self trendsWithDict:[dict objectForKey:@"trends"]];
    aite.comment = [self commentWithDict:[dict objectForKey:@"comment"]];

    return aite;
}

- (YWSupportModel *)supportWithDict:(NSDictionary *)dict {
    YWSupportModel *support = [[YWSupportModel alloc] init];
    support.supportType = [dict objectForKey:@"supportType"];
    if (![[dict objectForKey:@"comment"] isKindOfClass:[NSNull class]]) {
        support.comments = [self commentWithDict:[dict objectForKey:@"comment"]];
    }
    if (![[dict objectForKey:@"trends"] isKindOfClass:[NSNull class]]) {
        support.trends = [self trendsWithDict:[dict objectForKey:@"trends"]];
    }
    
    return support;
}

- (YWMovieCardModel *)movieCardWithDict:(NSDictionary *)dict {
    YWMovieCardModel *model = [[YWMovieCardModel alloc] init];
    model.cardId = [dict objectForKey:@"cardId"];
    model.authentication = [dict objectForKey:@"authentication"];
    model.address = [dict objectForKey:@"address"];
    model.age = [dict objectForKey:@"age"];
    model.constellation = [dict objectForKey:@"constellation"];
    model.height = [dict objectForKey:@"height"];
    model.bwh = [dict objectForKey:@"bwh"];
    model.announce = [dict objectForKey:@"announce"];
    model.email = [dict objectForKey:@"email"];
    model.info = [dict objectForKey:@"info"];
    if ([[dict objectForKey:@"trends"] isKindOfClass:[NSArray class]]) {
        model.trends = [self trendsWithArray:[dict objectForKey:@"trends"]];
    }else {
        model.trends = @[[self trendsWithDict:[dict objectForKey:@"trends"]]];
    }
    
    return model;
}

- (NSArray *)movieWithArray:(NSArray *)array {
    NSMutableArray *movies = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [movies addObject:[self movieWithDict:obj]];
    }];
    
    return movies;
}

- (NSArray *)subsectionVideoWithArray:(NSArray *)array {
    NSMutableArray *subsectionVideos = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [subsectionVideos addObject:[self subsectionVideoWithDict:obj]];
    }];
    
    return subsectionVideos;
}

- (NSArray *)trendsWithArray:(NSArray *)array {
    NSMutableArray *trends = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [trends addObject:[self trendsWithDict:obj]];
    }];
    
    return trends;
}

- (NSArray *)commentsWithArray:(NSArray *)array {
    NSMutableArray *comments = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [comments addObject:[self commentWithDict:obj]];
    }];
    
    return comments;
}

- (NSArray *)userWithArray:(NSArray *)array {
    NSMutableArray *users = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [users addObject:[self userWithDict:obj]];
    }];
    
    return users;
}

- (NSArray *)templateWithArray:(NSArray *)array {
    NSMutableArray *templates = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [templates addObject:[self templateWithDict:obj]];
    }];
    
    return templates;
}

- (NSArray *)articleWithArray:(NSArray *)array {
    NSMutableArray *articles = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [articles addObject:[self articleWithDict:obj]];
    }];
    
    return articles;
}

- (NSArray *)aiTeWithArray:(NSArray *)array {
    NSMutableArray *aiTis = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [aiTis addObject:[self aiTesWithDict:obj]];
    }];
    
    return aiTis;
}

- (NSArray *)supportWithArray:(NSArray *)array {
    NSMutableArray *supports = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [supports addObject:[self supportWithDict:obj]];
    }];
    
    return supports;
}

- (NSArray *)movieCardWithArray:(NSArray *)array {
    NSMutableArray *supports = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [supports addObject:[self movieCardWithDict:obj]];
    }];
    
    return supports;
}


@end
