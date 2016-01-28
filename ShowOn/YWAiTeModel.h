//
//  YWAiTeModel.h
//  ShowOn
//
//  Created by David Yu on 28/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWTrendsModel;
@class YWCommentModel;
@interface YWAiTeModel : NSObject

@property (nonatomic, strong) NSString *aiTeType;
@property (nonatomic, strong) YWTrendsModel *trends;
@property (nonatomic, strong) YWCommentModel *comment;

@end
