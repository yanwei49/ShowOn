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

@interface YWUserDataViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, YWMineTableHeadViewDelegate, YWCustomSegViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation YWUserDataViewController
{
    YWMineTableHeadView    *_headView;
    UITableView            *_tableView;
    YWCustomSegView        *_itemView;
    NSMutableArray         *_dataSource;
    NSMutableArray         *_trendsArray;
    NSInteger               _itemSelectIndex;
    NSArray                *_constellationArray;
    NSArray                *_sexArray;
    NSInteger               _selectIndex;
    UIView                 *_dataPickerBackView;
    UIDatePicker           *_dataPicker;
    UIPickerView           *_pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Subject_color;
    _dataSource = [[NSMutableArray alloc] initWithArray:@[@"个人签名", @"性别", @"地区", @"年龄", @"星座", @"身高", @"三围"]];
    _sexArray = @[@"男", @"女"];
    _constellationArray = @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];
    _trendsArray = [[NSMutableArray alloc] init];
    _itemSelectIndex = 0;

    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [self createSubViews];
    [self dataSource];
}

- (void)dataSource {
    for (NSInteger i=0; i<5; i++) {
        [_trendsArray addObject:@""];
    }
    [_tableView reloadData];
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

#pragma mark - action
- (void)actionCancel:(UIButton *)button {
    _dataPickerBackView.hidden = YES;
}

- (void)actionDown:(UIButton *)button {
    _dataPickerBackView.hidden = YES;
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UITextField *tf = (UITextField *)cell.accessoryView;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    tf.text = [formatter stringFromDate:_dataPicker.date];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_selectIndex == 1) {
        return _sexArray.count;
    }else {
        return _constellationArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_selectIndex == 1) {
        return _sexArray[row];
    }else {
        return _constellationArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    pickerView.hidden = YES;
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
    UITextField *tf = (UITextField *)cell.accessoryView;
    tf.text = (_selectIndex == 1)?_sexArray[row]:_constellationArray[row];
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
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-200, cell.bounds.size.height)];
        tf.delegate = self;
        tf.textColor = [UIColor whiteColor];
        tf.textAlignment = NSTextAlignmentRight;
        tf.font = [UIFont systemFontOfSize:15];
        cell.accessoryView = tf;
        tf.userInteractionEnabled = (!_isSelf)?NO:YES;
        if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4) {
            tf.userInteractionEnabled = NO;
        }
        
        return cell;
    }else {
        YWTrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return !_itemSelectIndex?50:[YWTrendsTableViewCell cellHeightWithTrends:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_itemSelectIndex) {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [cell.accessoryView becomeFirstResponder];
        [self didSelectCellWithIndex:indexPath.row];
    }
}

- (void)didSelectCellWithIndex:(NSInteger)index {
    [self hiddenPickView];
    _selectIndex = index;
    switch (index) {
        case 1:
        case 4:
            _pickerView.hidden = NO;
            [_pickerView reloadAllComponents];
            break;
        case 3:
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

#pragma mark - YWCustomSegViewDelegate
- (void)customSegView:(YWCustomSegView *)view didSelectItemWithIndex:(NSInteger)index {
    _itemSelectIndex = index;
    [self hiddenPickView];
    [_tableView reloadData];
}

#pragma mark - YWMineTableHeadViewDelegate
- (void)mineTableHeadView:(YWMineTableHeadView *)view didSelectButtonWithIndex:(NSInteger)index {
    
}

- (void)mineTableHeadViewDidSelectFocus {
    
}

- (void)mineTableHeadViewDidSelectSendMessage {
    
}

@end
