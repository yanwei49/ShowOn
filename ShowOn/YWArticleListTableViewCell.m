
//
//  YWArticleListTableViewCell.m
//  ShowOn
//
//  Created by David Yu on 16/1/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "YWArticleListTableViewCell.h"
#import "YWArticleModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation YWArticleListTableViewCell
{
    UILabel     *_titleLabel;
    UILabel     *_authorLabel;
    UIImageView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBColor(42, 42, 42);
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBColor(42, 42, 42);
        self.selectedBackgroundView = view;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = RGBColor(42, 42, 42);
        [self.contentView addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(10);
            make.right.offset(-10);
            make.bottom.offset(0);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_top).offset(10);
            make.left.equalTo(_imageView.mas_left).offset(10);
            make.height.offset(20);
        }];
        
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.textColor = [UIColor whiteColor];
        _authorLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_authorLabel];
        [_authorLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel.mas_left);
            make.height.offset(20);
        }];
    }
    
    return self;
}

- (void)setArticle:(YWArticleModel *)article {
    _article = article;
    _titleLabel.text = _article.articleTitle;
    _authorLabel.text = _article.articleAuthorName;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_article.articleCoverImage] placeholderImage:kPlaceholderArticleImage];
}

@end
