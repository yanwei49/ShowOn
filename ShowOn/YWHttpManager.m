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

#define kHostURL               @""
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
    [_httpManager POST:HOST_URL(Reginster_Verification_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [_httpManager POST:HOST_URL(Login_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [_httpManager GET:HOST_URL(Support_Method) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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




@end
