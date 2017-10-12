//
//  AddThingsViewController.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "AddThingsViewController.h"
#import "AddTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "SettingTableViewCell.h"
#import "AddViewModel.h"
#import "PickerView.h"
#import "DateView.h"

@interface AddThingsViewController ()<UITableViewDelegate, UITableViewDataSource, TFDelegate, DateViewDelegate, PickerViewDelegate, SwitchCellDelegate> {
    AddViewModel *_viewmodel;
    PickerView *_picker;
    DateView *_datePicker;
    NSIndexPath *_currentIndex;//当前的cell
    HomeModel *_home;//从首页push还是详情push过来
    BOOL _hasData;//是否有数据
}

@property (weak, nonatomic) IBOutlet UITableView *addTable;

@end

@implementation AddThingsViewController

- (instancetype)initWithModel:(HomeModel *)model {
    if (self = [super init]) {
        _home = model;
        if (model != nil) {//修改
            _hasData = YES;
        } else {//新建
            _hasData = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initViewModelBinding {
    _viewmodel = [[AddViewModel alloc] init];
}

- (void)initUIView {
    [self setBackButton:YES];
    if (_hasData) {//从详情push过来 修改
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(0, 0, Screen_Width, 50);
        [deleteBtn setBackgroundColor:[UIColor whiteColor]];
        deleteBtn.alpha = 0.5;
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor hexStringToColor:@"#333333"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteThing) forControlEvents:UIControlEventTouchUpInside];
        self.addTable.tableFooterView = deleteBtn;
    } else {
        self.addTable.tableFooterView = [UIView new];
    }
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(0, 0, 50, 40);
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [finishBtn setTitle:@"保存" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor hexStringToColor:@"#333333"] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(addFinished) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
    [self addNavigationWithTitle:@"新建事件" leftItem:nil rightItem:rightItem titleView:nil];
}

//新建 - 完成
- (void)addFinished {
    @weakSelf(self);
    
    [_viewmodel saveDataWithModel:_home success:^(BOOL result) {
        if (result) {
            [weakSelf goRootBack];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"failure");
    }];
}

//修改 - 删除
- (void)deleteThing {
    [_viewmodel deleteDataWithModel:_home success:^(BOOL result) {
        if (result) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"failure");
    }];
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"AddTableViewCell" owner:nil options:nil].firstObject;
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *title = [NSArray arrayWithObjects:@"事件名", @"", @"", @"", nil];
        NSString *str = _hasData ? _home.title : nil;
        [cell setDataWithTitle:title[indexPath.row] tfText:str];
        
        return cell;
        
    } else if (indexPath.row == 2) {
        SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SwitchTableViewCell" owner:nil options:nil].firstObject;
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *title = [NSArray arrayWithObjects:@"", @"", @"置顶", @"", nil];
        BOOL isOn = _hasData ? _home.isTop : NO;
        [cell setTitleWithStr:title[indexPath.row] isOn:isOn];
        
        return cell;
        
    } else {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:nil options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableArray *title = [NSMutableArray arrayWithObjects:@"", @"日期", @"", @"重复", nil];
        NSMutableArray *detail = [NSMutableArray arrayWithObjects:@"", @"选择", @"", @"选择",  nil];
        
        if (_hasData) {//修改时 有数据，显示数据
            [detail replaceObjectAtIndex:1 withObject:_home.date==nil?@"":_home.date];
            [detail replaceObjectAtIndex:3 withObject:_home.repeatType==nil?@"":_home.repeatType];
        }

        [cell setDataWithTitle:title[indexPath.row] detailTitle:detail[indexPath.row]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath;
    if (indexPath.row == 1) {//时间选择
        [self showDatePicker];
        [_datePicker showDateView];
    } else if (indexPath.row == 3) {//重复选择
        NSArray *arr = [NSArray arrayWithObjects:@"无重复", @"每周", @"每月", @"每年", nil];
        [self showPicker];
        _picker.rowsArr = [NSMutableArray arrayWithArray:arr];
        [_picker showInView];
    } else {
        [_datePicker removeFromSuperview];
        [_picker removeFromSuperview];
    }
}

#pragma mark - addcell delegate 
//输入完成
- (void)finishedWithText:(NSString *)text {
    _viewmodel.home.title = text;
}

#pragma mark - date
- (void)showDatePicker {
    if (_datePicker == nil) {
        _datePicker = [[NSBundle mainBundle] loadNibNamed:@"DateView" owner:nil options:nil].firstObject;
        _datePicker.frame = ScreenBounds;
        _datePicker.delegate = self;
    }
}

//将picker所选中的行的时间传给cell，并将title传给viewmodel
- (void)dateForRow:(NSString *)dateStr {
    SettingTableViewCell *cell = [self.addTable cellForRowAtIndexPath:_currentIndex];
    cell.detailLab.text = dateStr;
    _viewmodel.home.date = cell.detailLab.text;
}

- (void)datePickerWillHide {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
}

#pragma mark - picker
- (void)showPicker {
    if (_picker == nil) {
        _picker = [[NSBundle mainBundle] loadNibNamed:@"PickerView" owner:nil options:nil].firstObject;
        _picker.frame = ScreenBounds;
        _picker.delegate = self;
    }
}
//将picker所选中的行的title传给cell，并将title传给viewmodel
- (void)title:(NSString *)title row:(NSInteger)row {
    SettingTableViewCell *repeatCell = [self.addTable cellForRowAtIndexPath:_currentIndex];
    repeatCell.detailLab.text = title;
    _viewmodel.home.repeatType = repeatCell.detailLab.text;
}

#pragma mark - switch
- (void)isOpenTheSwitch:(BOOL)isOpen {
    _viewmodel.home.isTop = isOpen;
}


@end
