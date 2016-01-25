//
//  YWHotDetailViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/4.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWHotDetailViewController.h"
#import "YWMovieModel.h"
#import "YWFocusTableViewCell.h"
#import "YWMovieCommentTableViewCell.h"
#import "YWMovieOtherInfosTableViewCell.h"
#import "YWUserDataViewController.h"
#import "YWWriteCommentViewController.h"
#import "YWNavigationController.h"
#import "UMSocialSnsService.h"
#import "UMSocialData.h"
#import "UMSocial.h"


#import "YWUserModel.h"
#import "YWCommentModel.h"
#import "YWTrendsModel.h"
#import "YWMovieTemplateModel.h"

@interface YWHotDetailViewController()<UITableViewDataSource, UITableViewDelegate, YWFocusTableViewCellCellDelegate, YWMovieCommentTableViewCellDelegate, YWMovieOtherInfosTableViewCellDelegate>

@end

@implementation YWHotDetailViewController
{
    UITableView         *_tableView;
    UIButton            *_commentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    self.title = _trends.trendsMovie.movieTemplate.templateName;
    [self createRightItemWithTitle:@"..."];
    
    [self createSubViews];
//    [self dataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//- (void)dataSource {
//    _movie = [[YWMovieModel alloc] init];
//    _movie.movieId = @"1";
//    _movie.moviePlayNumbers = @"221";
//    _movie.movieTimeLength = @"02:12";
//    _movie.movieName = @"测试模板1";
//    _movie.movieRecorderType = @"1";
//    _movie.movieIsSupport = [NSString stringWithFormat:@"%d", arc4random()%2];
//    YWUserModel *user = [[YWUserModel alloc] init];
//    user.userId = @"1";
//    user.portraitUri = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
//    user.userName = @"用户1";
//    YWUserModel *user1 = [[YWUserModel alloc] init];
//    user1.userId = @"2";
//    user1.portraitUri = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
//    user1.userName = @"用户2";
//    YWUserModel *user2 = [[YWUserModel alloc] init];
//    user2.userId = @"3";
//    user2.portraitUri = @"http://www.51qnz.cn/photo/image/merchant/201510287110532762.jpg";
//    user2.userName = @"用户3";
//    _movie.movieReleaseUser = user;
//    _movie.movieRecorderState = @"1";
//    _movie.moviePlayers = @[user1, user2];
//    _movie.movieIsSupport = @"1";
//    _movie.movieIsCollect = @"1";
//    _movie.movieSupports = @"211";
//    NSMutableArray *comments = [NSMutableArray array];
//    for (NSInteger i=0; i<4; i++) {
//        YWCommentModel *comment = [[YWCommentModel alloc] init];
//        comment.commentId = @"1";
//        comment.commentUser = user1;
//        comment.commentTime = @"2015-10-02 03:21";
//        comment.commentContent = @"E区 俄武器和全文请二位ii恶趣味哦i恶趣味哦恶趣味  阿胶去我i我去额偶王企鹅我企鹅";
//        comment.isSupport = @"1";
//        [comments addObject:comment];
//    }
//    _movie.movieComments = comments;
//    
//    [_tableView reloadData];
//}

- (void)createSubViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[YWFocusTableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[YWMovieCommentTableViewCell class] forCellReuseIdentifier:@"commentCell"];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[YWMovieOtherInfosTableViewCell class] forCellReuseIdentifier:@"sCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(-49);
    }];
    
    _commentView = [[UIButton alloc] init];
    _commentView.backgroundColor = Subject_color;
    [_commentView addTarget:self action:@selector(actionWriteComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentView];
    [_commentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(49);
    }];
    
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = @"  说点什么";
    tf.userInteractionEnabled = NO;
    tf.font = [UIFont systemFontOfSize:15];
    tf.backgroundColor = [UIColor whiteColor];
    tf.layer.masksToBounds = YES;
    tf.layer.cornerRadius = 7;
    [_commentView addSubview:tf];
    [tf makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(_commentView.mas_centerY);
        make.height.offset(35);
        make.right.offset(-60);
    }];
    
    UIButton *sendButton = [[UIButton alloc] init];
    sendButton.userInteractionEnabled = NO;
    sendButton.backgroundColor = Subject_color;
    [sendButton setTitle:@"发布" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_commentView addSubview:sendButton];
    [sendButton makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.right.offset(-5);
        make.centerY.equalTo(_commentView.mas_centerY);
        make.height.offset(35);
    }];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"举报" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"带有色情或政治内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"其    他" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取    消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }]];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)actionWriteComment:(UIButton *)button {
    YWWriteCommentViewController *vc = [[YWWriteCommentViewController alloc] init];
    YWNavigationController *nv = [[YWNavigationController alloc] initWithRootViewController:vc];
    nv.title = @"写评论";
    [self presentViewController:nv animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2+_trends.trendsComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            YWFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.delegate = self;
            cell.trends = _trends;
            
            return cell;
        }
            break;
        case 1:
        {
            YWMovieOtherInfosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.trends = _trends;

            return cell;
        }
            break;
        default:
        {
            YWMovieCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
            cell.delegate = self;
            cell.comment = _trends.trendsComments[indexPath.row-2];

            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return [YWFocusTableViewCell cellHeightWithTrends:_trends type:kTrendsDetailType];
            break;
        case 1:
            return 100;
            break;
        default:
            return [YWMovieCommentTableViewCell cellHeightWithComment:_trends.trendsComments[indexPath.row-2]];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - YWFocusTableViewCellCellDelegate
- (void)focusTableViewCellDidSelectCooperate:(YWFocusTableViewCell *)cell {
    if (false) {

    }else {
        [self login];
    }
}

- (void)focusTableViewCellDidSelectPlay:(YWFocusTableViewCell *)cell {
    if (false) {
        
    }else {
        [self login];
    }
}

#pragma mark - YWMovieOtherInfosTableViewCellDelegate
- (void)movieOtherInfosTableViewCellDidSelectShare:(YWMovieOtherInfosTableViewCell *)cell {
    if (true) {
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UMengAppKey shareText:@"来自【角儿】" shareImage:nil shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,UMShareToQQ] delegate:nil];
        NSString *url = @"http://www.baidu.com";
        NSString *title = _trends.trendsContent.length>0?_trends.trendsContent:@"";
        [UMSocialData defaultData].extConfig.qqData.url = url;
        [UMSocialData defaultData].extConfig.qzoneData.url =  url;
        [UMSocialData defaultData].extConfig.qqData.title =  title;
        [UMSocialData defaultData].extConfig.qzoneData.title =  title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url =  url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url =  url;
        [UMSocialData defaultData].extConfig.wechatSessionData.title =  title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title =  title;
    }else {
        [self login];
    }
}

- (void)movieOtherInfosTableViewCellDidSelectSupport:(YWMovieOtherInfosTableViewCell *)cell {
    if (false) {
        
    }else {
        [self login];
    }
}

- (void)movieOtherInfosTableViewCellDidSelectCollect:(YWMovieOtherInfosTableViewCell *)cell {
    if (false) {
        
    }else {
        [self login];
    }
}

- (void)movieOtherInfosTableViewCell:(YWMovieOtherInfosTableViewCell *)cell didSelectUserAvator:(YWUserModel *)user {
    YWUserDataViewController *vc = [[YWUserDataViewController alloc] init];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YWMovieCommentTableViewCellDelegate
- (void)movieCommentTableViewCellDidSelectSupport:(YWMovieCommentTableViewCell *)cell {
    if (false) {
        
    }else {
        [self login];
    }
}


@end
