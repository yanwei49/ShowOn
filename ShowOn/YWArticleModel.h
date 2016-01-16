//
//  YWArticleModel.h
//  ShowOn
//
//  Created by David Yu on 16/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWArticleModel : NSObject

@property (nonatomic, strong) NSString   *articleId;               //文章id
@property (nonatomic, strong) NSString   *articleTitle;            //文章标题
@property (nonatomic, strong) NSString   *articleAuthorName;       //文章作者名字
@property (nonatomic, strong) NSString   *articleCoverImage;       //文章封面图片
@property (nonatomic, strong) NSString   *articleUrl;              //文章HTML链接

@end
