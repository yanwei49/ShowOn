//
//  YWSearchCollectionReusableView.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/3.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWSearchCollectionReusableView.h"
#import "YWCustomSegView.h"
#import "YWSearchViewController.h"

@interface YWSearchCollectionReusableView ()<UISearchBarDelegate, YWCustomSegViewDelegate>

@end

@implementation YWSearchCollectionReusableView
{
    UISearchBar       *_searchBar;
    YWCustomSegView   *_itemView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Subject_color;
        
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索片名/用户名";
        _searchBar.delegate = self;
        [self addSubview:_searchBar];
        [_searchBar makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(40);
        }];
        
        NSArray  *titles = @[@"名人专场", @"视频分类", @"应用模板"];
        _itemView = [[YWCustomSegView alloc] initWithItemTitles:titles];
        _itemView.hiddenLineView = NO;
        _itemView.delegate = self;
        [self addSubview:_itemView];
        [_itemView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_searchBar.mas_bottom);
            make.left.offset(0);
            make.right.offset(0);
            make.height.offset(40);
        }];
    }
    
    return self;
}

- (void)setItemShowState:(BOOL)itemShowState {
    _itemShowState = itemShowState;
    _itemView.hidden = itemShowState;
}

#pragma mark - YWCustomSegViewDelegate
- (void)customSegView:(YWCustomSegView *)view didSelectItemWithIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(searchCollectionReusableView:didSelectItemWithIndex:)]) {
        [_delegate searchCollectionReusableView:self didSelectItemWithIndex:index];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_searchBar resignFirstResponder];
    
}


@end
