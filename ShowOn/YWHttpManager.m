//
//  YWHttpManager.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHttpManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "YWHttpGlobalDefine.h"
#import "YWSubsectionVideoModel.h"

//#define kHostURL               @"http://120.25.146.161/"
#define kHostURL               @"http://192.168.1.136:8080/"
#define HOST_URL(methodName)   [NSString stringWithFormat:@"%@%@",kHostURL,methodName]

@interface YWHttpManager()
{
    AFHTTPRequestOperationManager *_httpManager;
}

@end

@implementation YWHttpManager

static YWHttpManager * manager;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YWHttpManager alloc] init];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        _httpManager = [AFHTTPRequestOperationManager manager];
    }
    
    return self;
}

- (void)setDefaultHeaders {
    [_httpManager.requestSerializer setTimeoutInterval:TIME_OUT];
    [_httpManager.requestSerializer setValue:BUNDLE_VERSION forHTTPHeaderField:VERSION_HEADER];
}

- (void)cancelRequest {
    [[_httpManager operationQueue] cancelAllOperations];
}

- (void) responseObjectParser:(id)responseObject success:(void (^) (id responseObject))success otherFailure:(void (^)(id responseObject))otherFailure {
    NSDictionary *resultDic = responseObject;
    NSInteger responseKey = [[resultDic objectForKey:@"code"] integerValue];
    switch (responseKey) {
        case 200:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(resultDic);
            });
        }
            break;
        case 400:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:resultDic[@"msg"]];
                otherFailure(resultDic);
            });
        }
            break;
        default:
            break;
    }
}


- (void)requestVerification:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure{
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Verification_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestRegister:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager POST:HOST_URL(Register_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestLogin:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Login_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestResetPassword:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager POST:HOST_URL(Reset_Password_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestTemplateList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Template_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestArticleList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Article_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestTemplateDetail:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Template_Detail_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestTrendsList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Trends_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestFriendsTrendsList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Friend_Trends_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestTrendsDetail:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Trends_Detail_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestUserDetail:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(User_Detail_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestSaveUserDetails:(NSDictionary *)parameters image:(UIImage *)image success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager POST:HOST_URL(Save_User_Detail_Method) parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (image) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"img" fileName:@"test.png" mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)requestUserList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(User_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestCollectList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Collect_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestAiTeList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(AiTe_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestCommentList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Comment_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestSupportList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Support_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestDraftList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Draft_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestSupport:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Support_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestChangeRelationType:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Change_Relation_Type_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestWeiBoFriendList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(@"https://api.weibo.com/2/friendships/friends.json") parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestSearch:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Search_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestReport:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Report_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestFeedback:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Feedback_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestRepeat:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager POST:HOST_URL(Repeat_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestShare:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Share_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestCollect:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Collect_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestWriteTrends:(NSDictionary *)parameters coverImage:(UIImage *)image recorderMovies:(NSArray *)recorderMovies movieUrl:(NSURL *)movieUrl success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager POST:HOST_URL(Save_Trends_Method) parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (movieUrl) {
            NSData *data = [NSData dataWithContentsOfURL:movieUrl];
            [formData appendPartWithFileData:data name:@"video" fileName:@"video.mov" mimeType:@"video/quicktime"];
        }else {
            for (NSInteger i=0; i<recorderMovies.count; i++) {
                YWSubsectionVideoModel *model = recorderMovies[i];
                if (model.recorderVideoUrl) {
                    NSError *error;
                    NSData *data = [NSData dataWithContentsOfURL:model.recorderVideoUrl options:NSDataReadingMappedIfSafe error:&error];
                    if (error) {
                        DebugLog(@"%@====", error);
                    }
                    if (data) {
                        [formData appendPartWithFileData:data name:@"video" fileName:[NSString stringWithFormat:@"video%@-%@-%@.mov", model.subsectionVideoType, model.subsectionVideoSort, model.subSort] mimeType:@"video/quicktime"];
                    }
                }
            }
        }
        if (image) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"img" fileName:@"test.png" mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)requestPlay:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Play_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestWeiBoUser:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(WeiBo_User_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestTemplateSubCategory:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Template_Sub_Category_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestTemplateSubCategoryList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Template_Sub_Category_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestTemplatePlayUserList:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Template_User_List_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)requestCommitComment:(NSDictionary *)parameters success:(void (^) (id responseObject))success otherFailure:(void (^) (id responseObject))otherFailure failure:(void (^) (NSError * error))failure {
    [self setDefaultHeaders];
    [_httpManager GET:HOST_URL(Commit_Comment_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self responseObjectParser:responseObject success:success otherFailure:otherFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

@end
