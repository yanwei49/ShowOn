//
//  YWUserDataViewController.m
//  ShowOn
//
//  Created by 颜魏 on 15/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWUserDataViewController.h"
#import "YWMineTableHeadView.h"
#import "YWCustomSegView.h"
#import "YWChatRoomViewComtroller.h"
#import "YWTrendsTableViewCell.h"
#import "YWHttpManager.h"
#import "YWParser.h"
#import "YWUserModel.h"
#import "YWTrendsModel.h"
#import "YWTrendsDetailViewController.h"
#import "YWTrendsCategoryView.h"
#import "YWDataBaseManager.h"
#import "YWTrendsViewController.h"
#import "YWFollowingViewController.h"
#import "YWCollectionViewController.h"
#import "YWMovieModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMoviePlayerViewController+Rotation.h"
#import "YWTranscribeViewController.h"

@interface YWUserDataViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, YWMineTableHeadViewDelegate, YWCustomSegViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, YWTrendsTableViewCellDelegate, YWTrendsCategoryViewDelegate, UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation YWUserDataViewController
{
    YWMineTableHeadView    *_headView;
    UITableView            *_tableView;
    YWCustomSegView        *_itemView;
    NSMutableArray         *_dataSource;
    NSMutableArray         *_trendsArray;
    NSMutableArray         *_allTrendsArray;
    NSInteger               _itemSelectIndex;
    NSArray                *_constellationArray;
    NSArray                *_sexArray;
    NSInteger               _selectIndex;
    UIView                 *_dataPickerBackView;
    UIDatePicker           *_dataPicker;
    UIPickerView           *_pickerView;
    YWHttpManager          *_httpManager;
    NSInteger               _trendsType;
    YWTrendsCategoryView   *_categoryView;
    YWTrendsCategoryView   *_userCategoryView;
    UIImage                *_headImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    if ([_user.userId isEqualToString:[[YWDataBaseManager shareInstance] loginUser].userId]) {
        _isSelf = YES;
        [self createRightItemWithTitle:@"保存"];
    }else {
        _isSelf = NO;
        [self createRightItemWithImage:@"more_normal.png"];
    }
    _httpManager = [YWHttpManager shareInstance];
    _dataSource = [[NSMutableArray alloc] initWithArray:@[@"昵称",@"个人签名", @"性别", @"地区", @"年龄", @"星座", @"身高", @"三围"]];
    _sexArray = @[@"男", @"女"];
    _constellationArray = @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];
    _trendsArray = [[NSMutableArray alloc] init];
    _allTrendsArray = [[NSMutableArray alloc] init];
    _itemSelectIndex = 0;

    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)dealloc {
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)createSubViews {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    view.backgroundColor = Subject_color;
    
    _headView = [[YWMineTableHeadView alloc] initWithFrame:CGRectZero withUserIsSelf:_isSelf];
    _headView.delegate = self;
    _headView.user = _user;
    [view addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(200);
    }];
    
    NSArray  *titles = @[@"资料", @"动态"];
    _itemView = [[YWCustomSegView alloc] initWithItemTitles:titles];
    _itemView.hiddenLineView = NO;
    _itemView.hiddenBottomLineView = YES;
    _itemView.delegate = self;
    _itemView.ywBackgroundColor = RGBColor(52, 52, 52);
    _itemView.ywSelectBackgroundColor = RGBColor(52, 52, 52);
    [view addSubview:_itemView];
    [_itemView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(40);
    }];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = Subject_color;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    _tableView.separatorColor = RGBColor(30, 30, 30);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[YWTrendsTableViewCell class] forCellReuseIdentifier:@"cell1"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = view;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    _dataPickerBackView = [[UIView alloc] init];
    _dataPickerBackView.backgroundColor = RGBColor(234, 234, 234);
    _dataPickerBackView.hidden = YES;
    [self.view addSubview:_dataPickerBackView];
    [_dataPickerBackView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(260);
    }];
    
    _dataPicker = [[UIDatePicker alloc] init];
    _dataPicker.backgroundColor = [UIColor whiteColor];
    _dataPicker.datePickerMode = UIDatePickerModeDate;
    [_dataPickerBackView addSubview:_dataPicker];
    [_dataPicker makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(220);
    }];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = RGBColor(234, 234, 234);
    [cancelButton addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    [_dataPickerBackView addSubview:cancelButton];
    [cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.width.offset(80);
        make.height.offset(40);
    }];
    
    UIButton *downButton = [[UIButton alloc] init];
    [downButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downButton setTitle:@"确认" forState:UIControlStateNormal];
    downButton.backgroundColor = RGBColor(234, 234, 234);
    [downButton addTarget:self action:@selector(actionDown:) forControlEvents:UIControlEventTouchUpInside];
    [_dataPickerBackView addSubview:downButton];
    [downButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.width.offset(80);
        make.height.offset(40);
    }];
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.hidden = YES;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pickerView];
    [_pickerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(220);
    }];
}

- (void)hiddenPickView {
    _pickerView.hidden = YES;
    _dataPickerBackView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestUserDetails];
}

#pragma mark - action
- (void)actionRightItem:(UIButton *)button {
    if ([_user.userId isEqualToString:[[YWDataBaseManager shareInstance] loginUser].userId]) {
        [self requestSaveUserDetails];
    }else {
        NSArray *array = @[@"举报", @"拉黑"];
        if (_userCategoryView) {
            _userCategoryView.hidden = !_userCategoryView.hidden;
        }else {
            _userCategoryView = [[YWTrendsCategoryView alloc] init];
            _userCategoryView.delegate = self;
            _userCategoryView.categoryArray = array;
            [self.view addSubview:_userCategoryView];
        }
        [_userCategoryView makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(70);
            make.height.offset(array.count*30);
            make.top.offset(64);
            make.right.offset(-10);
        }];
    }
}

- (void)actionCancel:(UIButton *)button {
    _dataPickerBackView.hidden = YES;
}

- (void)actionDown:(UIButton *)button {
    _dataPickerBackView.hidden = YES;
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    UITextField *tf = (UITextField *)cell.accessoryView;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    tf.text = [formatter stringFromDate:_dataPicker.date];
}

- (void)actionTrendsCategoryOnClick:(UIButton *)button {
    NSArray *array = @[@"全部", @"原创", @"合作", @"转发"];
    if (_categoryView) {
        _categoryView.hidden = !_categoryView.hidden;
    }else {
        _categoryView = [[YWTrendsCategoryView alloc] init];
        _categoryView.delegate = self;
        _categoryView.categoryArray = array;
        [self.view addSubview:_categoryView];
    }
    [_categoryView makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(array.count*30);
        make.top.equalTo(button.mas_bottom);
        make.centerX.equalTo(button.mas_centerX);
    }];
}

- (void)actionAvator {
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [sheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self actionTakePhoto];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self actionAblum];
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:sheet animated:YES completion:nil];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionTakePhoto {
    UIImagePickerController *albumPicker = [[UIImagePickerController alloc] init];
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:
                     UIImagePickerControllerCameraDeviceRear ||
                     UIImagePickerControllerCameraDeviceFront];
    if (!isCamera) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有可用摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    //拍照
    albumPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    albumPicker.delegate = self;
    [self presentViewController:albumPicker animated:YES completion:NULL];
}

- (void)actionAblum {
    UIImagePickerController *albumPicker = [[UIImagePickerController alloc] init];
    albumPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    albumPicker.delegate = self;
    [self presentViewController:albumPicker animated:YES completion:NULL];
}

#pragma mark - request
- (void)requestUserDetails {
    NSDictionary *parameters = @{@"userId": _user.userId, @"loginUserId": [[YWDataBaseManager shareInstance] loginUser].userId?:@""};
    [_httpManager requestUserDetail:parameters success:^(id responseObject) {
        [_allTrendsArray removeAllObjects];
        [_trendsArray removeAllObjects];
        YWParser *parser = [[YWParser alloc] init];
        NSString *userId = _user.userId;
        _user = [parser userWithDict:responseObject[@"user"]];
        _user.userId = userId;
        [_allTrendsArray addObjectsFromArray:_user.userTrends];
        [_trendsArray addObjectsFromArray:_allTrendsArray];
        _headView.user = _user;
        if (_headImage) {
            _headView.headImage = _headImage;
        }
        [_tableView reloadData];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestSaveUserDetails {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i=0; i<8; i++) {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *tf = (UITextField *)cell.accessoryView;
        [array addObject:tf.text?:@""];
    }
    [SVProgressHUD showWithStatus:@"修改中..."];
    NSDictionary *parameters = @{@"userId": _user.userId, @"nickName": array[0], @"introduction": array[1], @"sex": [array[2] isEqualToString:@"女"]?@"2":@"1", @"district": array[3], @"birthday": array[4], @"constellation": array[5], @"height": array[6], @"bwh": array[7]};
    [_httpManager requestSaveUserDetails:parameters image:_headImage success:^(id responseObject) {
        YWParser *parser = [[YWParser alloc] init];
        _user = [parser userWithDict:responseObject[@"user"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[YWDataBaseManager shareInstance] cleanLoginUsers];
            [[YWDataBaseManager shareInstance] addLoginUser:_user];
        });
        [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
        [self.navigationController popViewControllerAnimated:YES];
    } otherFailure:^(id responseObject) {
        [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

- (void)requestSupportWithTrends:(YWTrendsModel *)trends {
    NSDictionary *parameters = @{@"userId": _user.userId, @"state": trends.trendsIsSupport?@"0":@"1"};
    [_httpManager requestSupport:parameters success:^(id responseObject) {
        trends.trendsIsSupport = trends.trendsIsSupport?@"0":@"1";
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_trendsArray indexOfObject:trends] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestReport {
    NSDictionary *parameters = @{@"userId": [[YWDataBaseManager shareInstance] loginUser].userId?:@"", @"informTypeId": @"1", @"informTargetId": _user.userId, @"informContent": @""};
    [_httpManager requestReport:parameters success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestBlacklist {
    NSDictionary *parameters = @{@"userId": _user.userId, @"state": @"1"};
    [_httpManager requestChangeRelationType:parameters success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestFocus {
    NSInteger state = 0;
    switch (_user.userRelationType) {
        case kEachOtherNoFocus:
            state = kFocus;
            break;
        case kFocus:
            state = kEachOtherNoFocus;
            break;
        case kBeFocus:
            state = kEachOtherFocus;
            break;
        case kBlackList:
            state = kEachOtherNoFocus;
            break;
        case kEachOtherFocus:
            state = kBeFocus;
            break;
        default:
            break;
    }
    NSDictionary *parameters = @{@"blackState": @(state), @"userId": [[YWDataBaseManager shareInstance] loginUser].userId, @"friendId": _user.userId};
    [_httpManager requestChangeRelationType:parameters success:^(id responseObject) {
        [self requestUserDetails];
//        _user.userRelationType = state;
//        _headView.user = _user;
    } otherFailure:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _headImage = image;
    _headView.headImage = _headImage;
    //关闭模态视图
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //关闭模态视图
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        [self actionTakePhoto];
    }else if (buttonIndex == 1) {
        [self actionAblum];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_selectIndex == 2) {
        return _sexArray.count;
    }else {
        return _constellationArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_selectIndex == 2) {
        return _sexArray[row];
    }else {
        return _constellationArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    pickerView.hidden = YES;
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
    UITextField *tf = (UITextField *)cell.accessoryView;
    tf.text = (_selectIndex == 2)?_sexArray[row]:_constellationArray[row];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return !_itemSelectIndex?_dataSource.count:_trendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_itemSelectIndex) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.backgroundColor = RGBColor(52, 52, 52);
        cell.contentView.backgroundColor = RGBColor(52, 52, 52);
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = _dataSource[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        NSArray *contents = @[_user.userName?:@"", _user.userInfos?:@"", _user.userSex?(_user.userSex.integerValue?@"男":@"女"):@"", _user.userDistrict?:@"", _user.userBirthday?:@"", _user.userConstellation?:@"", _user.userheight?:@"", _user.userBwh?:@""];
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-200, cell.bounds.size.height)];
        tf.delegate = self;
        tf.text = contents[indexPath.row];
        tf.textColor = [UIColor whiteColor];
        tf.textAlignment = NSTextAlignmentRight;
        tf.font = [UIFont systemFontOfSize:15];
        cell.accessoryView = tf;
        tf.userInteractionEnabled = (!_isSelf)?NO:YES;
        if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5) {
            tf.userInteractionEnabled = NO;
        }
        
        return cell;
    }else {
        YWTrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.trends = _trendsArray[indexPath.row];
        cell.delegate = self;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !_itemSelectIndex?50:[YWTrendsTableViewCell cellHeightWithTrends:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!_itemSelectIndex) {
        return 0.00001;
    }else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_itemSelectIndex) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        view.backgroundColor = RGBColor(50, 50, 50);
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = RGBColor(50, 50, 50);
        NSArray *array = @[@"全部", @"原创", @"合作", @"转发"];
        [button setTitle:[NSString stringWithFormat:@"%@ %ld", array[_trendsType], (unsigned long)_trendsArray.count] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(actionTrendsCategoryOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.width.offset(100);
            make.right.offset(-20);
        }];
        
        return view;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!_itemSelectIndex) {
        if (_isSelf) {
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            [cell.accessoryView becomeFirstResponder];
            [self didSelectCellWithIndex:indexPath.row];
        }
    }else {
        YWTrendsDetailViewController *hotVC = [[YWTrendsDetailViewController alloc] init];
        hotVC.trends = _trendsArray[indexPath.row];
        [self.navigationController pushViewController:hotVC animated:YES];
    }
}

- (void)didSelectCellWithIndex:(NSInteger)index {
    [self hiddenPickView];
    _selectIndex = index;
    switch (index) {
        case 2:
        case 5:
            _pickerView.hidden = NO;
            [_pickerView reloadAllComponents];
            break;
        case 4:
            _dataPickerBackView.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - YWTrendsCategoryViewDelegate
- (void)trendsCategoryView:(YWTrendsCategoryView *)view didSelectCategoryWithIndex:(NSInteger)index {
    if (view == _userCategoryView) {
        !index?[self requestReport]:[self requestBlacklist];
    }else {
        _trendsType = index;
        view.hidden = YES;
        [_trendsArray removeAllObjects];
        for (YWTrendsModel *trends in _allTrendsArray) {
            if (trends.trendsType.integerValue == index || !index) {
                [_trendsArray addObject:trends];
            }
        }
        [_tableView reloadData];
    }
}

#pragma mark - YWCustomSegViewDelegate
- (void)customSegView:(YWCustomSegView *)view didSelectItemWithIndex:(NSInteger)index {
    _itemSelectIndex = index;
    [self hiddenPickView];
    _userCategoryView.hidden = YES;
    _categoryView.hidden = YES;
    [_tableView reloadData];
}

#pragma mark - YWTrendsTableViewCellDelegate
- (void)trendsTableViewCellDidSelectSupportButton:(YWTrendsTableViewCell *)cell {
    [self requestSupportWithTrends:cell.trends];
}

- (void)trendsTableViewCellDidSelectPlaying:(YWTrendsTableViewCell *)cell {
    if (cell.trends.trendsMovie.movieUrl.length) {
        NSString *urlStr = [cell.trends.trendsMovie.movieUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        [moviePlayerViewController rotateVideoViewWithDegrees:90];
        [self presentViewController:moviePlayerViewController animated:YES completion:nil];
        [self requestPlayModelId:cell.trends.trendsId withType:2];
    }else {
        YWTranscribeViewController *vc = [[YWTranscribeViewController alloc] init];
        vc.trends = cell.trends;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - YWMineTableHeadViewDelegate
- (void)mineTableHeadView:(YWMineTableHeadView *)view didSelectButtonWithIndex:(NSInteger)index {
    if (_isSelf) {
        switch (index) {
            case 0:
            {
                YWTrendsViewController *vc = [[YWTrendsViewController alloc] init];
                vc.title = @"动态";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                YWFollowingViewController *vc = [[YWFollowingViewController alloc] init];
                vc.relationType = 1;
                vc.title = @"关注";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                YWFollowingViewController *vc = [[YWFollowingViewController alloc] init];
                vc.relationType = 2;
                vc.title = @"粉丝";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                YWCollectionViewController *vc = [[YWCollectionViewController alloc] init];
                vc.title = @"收藏";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }else {
        switch (index) {
            case 0:
            {
                YWFollowingViewController *vc = [[YWFollowingViewController alloc] init];
                vc.relationType = 1;
                vc.title = @"关注";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                YWFollowingViewController *vc = [[YWFollowingViewController alloc] init];
                vc.relationType = 2;
                vc.title = @"粉丝";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                YWTrendsViewController *vc = [[YWTrendsViewController alloc] init];
                vc.title = @"动态";
                vc.isFriendTrendsList = YES;
                vc.user = _user;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (void)mineTableHeadViewDidSelectFocus {
    [self requestFocus];
}

- (void)mineTableHeadViewDidSelectSendMessage {
    YWChatRoomViewComtroller *vc = [[YWChatRoomViewComtroller alloc] init];
    vc.conversationType = ConversationType_PRIVATE;
    vc.targetId = _user.userAccount;
    vc.userName = _user.userName;
    vc.title = _user.userName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mineTableHeadViewDidSelectAvator {
    [self actionAvator];
}

@end
