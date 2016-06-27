//
//  TLHttpGlobalDefine.h
//  GoFarmApp
//
//  Created by David Yu on 7/8/15.
//  Copyright (c) 2015年 唐农网络科技(深圳)有限公司. All rights reserved.
//

#ifndef GoFarmApp_TLHttpGlobalDefine_h
#define GoFarmApp_TLHttpGlobalDefine_h


//#define kHostURL               @"http://120.25.146.161/"
#define kHostURL               @"http://www.juerapp.com/"
//#define kHostURL               @"http://xazhb85.uicp.io/"

#define HOST_URL(methodName)   [NSString stringWithFormat:@"%@%@",kHostURL,methodName]

#define BUNDLE_VERSION                        [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]
#define TIME_OUT                              400
#define VERSION_HEADER                        @"version"

#define Register_Method                       @"juer/user/register?json"                    //注册
#define Login_Method                          @"juer/user/login?json"                       //登录
#define Verification_Method                   @"juer/user/getVerificationCode?json"         //获取验证码
#define Reset_Password_Method                 @"juer/user/resetPassword?json"               //重置密码
#define Template_List_Method                  @"juer/dynamic/templateRankList?json"         //模板列表
#define Template_Detail_Method                @"juer/dynamic/templateInfo?json"             //模板详情
#define Trends_List_Method                    @"juer/dynamic/trendsList?json"               //动态列表
#define Friend_Trends_List_Method             @"juer/dynamic/friendTrendsList?json"         //好友动态列表
#define Trends_Detail_Method                  @"juer/dynamic/trendsInfo?json"               //动态详情
#define Save_User_Detail_Method               @"juer/user/updateUserInfo?json"              //保存用户信息
#define User_Detail_Method                    @"juer/user/getUserInfo?json"                 //用户详情
#define User_List_Method                      @"juer/user/getFriendList?json"               //用户列表
#define Collect_List_Method                   @"juer/dynamic/collectList?json"              //收藏列表
#define AiTe_List_Method                      @"juer/dynamic/atList?json"                   //@我列表
#define Comment_List_Method                   @"juer/dynamic/commentList?json"              //评论列表
#define Support_List_Method                   @"juer/dynamic/supportList?json"              //点赞列表
#define Draft_List_Method                     @"juer/dynamic/getDraftsList?json"            //草稿箱列表
#define Support_Method                        @"juer/dynamic/praise?json"                   //点赞
#define Change_Relation_Type_Method           @"juer/user/updateRelationType?json"          //修改用户类型
#define Search_Method                         @"juer/dynamic/search?json"                   //搜索
#define Report_Method                         @"juer/user/inform?json"                      //举报
#define Feedback_Method                       @"juer/dynamic/feedBack?json"                 //用户反馈
#define Repeat_Method                         @"juer/dynamic/forwardDynamic?json"           //转发
#define Share_Method                          @"juer/dynamic/dynamicShare?json"             //动态分享
#define Collect_Method                        @"juer/dynamic/collection?json"               //收藏
#define Commit_Comment_Method                 @"juer/dynamic/comments?json"                 //发表评论
#define Save_Trends_Method                    @"juer/dynamic/draftOrDynamicVideo?json"      //发布动态、保存到草稿箱
#define Article_List_Method                   @"juer/dynamic/teletextList?json"             //图文列表
#define Play_Method                           @"juer/dynamic/statistics?json"               //播放统计
#define WeiBo_User_Method                     @"juer/dynamic/sinaUserList?json"             //微博用户
#define Template_Sub_Category_Method          @"juer/dynamic/moreTemplateType?json"         //获取模板子分类列表
#define Template_Sub_Category_List_Method     @"juer/dynamic/subTemplateList?json"          //获取模板某个子分类下的模板列表
#define Template_User_List_Method             @""             //获取模板表演用户列表
#define Delete_Comment_Method                 @"juer/dynamic/deleteComment?json"            //删除评论
#define Movie_List_Method                     @"juer/dynamic/videoList?json"                //获取可制作为名片的视频列表
#define Commit_Movie_Method                   @"juer/dynamic/videoCard?json"                //提交视频名片
#define Share_Movie_Method                    @"juer/dynamic/cardShare?json"                //视频名片分享
#define User_Protocol_Method                  @"juer/dynamic/protocol?json"                 //用户协议
#define Save_Casting_Method                   @"juer/user/introduceVideo?json"              //保存个人简介视频
#define Info_Movie_Template_Method            @"juer/user/introduceVideoTemplate?json"      //个人简介视频模板


#endif
