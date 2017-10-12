//
//  SettingViewController.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "PickerView.h"
#import "SetViewModel.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate, PickerViewDelegate> {
    NSDictionary *_localDic;
    NSIndexPath *_currentRow;//当前的cell
    PickerView *_picker;
    SetViewModel *_viewmodel;
    BOOL _hasData;//首页有数据，添加通知，否则不添加
}

@property (weak, nonatomic) IBOutlet UITableView *settingTable;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - 数据
- (void)initViewModelBinding {
    _viewmodel = [[SetViewModel alloc] init];
}

//加载数据
- (void)loadData {
    @weakSelf(self);
    [_viewmodel showDatasetDataSuccess:^(BOOL result) {
        if (result) {
            [weakSelf.settingTable reloadData];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"failure");
    }];
}

//完成
- (void)finished {
    @weakSelf(self);
    __block BOOL hasData = _hasData;
    [_viewmodel setDataSuccess:^(BOOL result) {
        if (result) {
            [weakSelf dateTypeChanged];
            
            if (hasData) {
                [weakSelf remindtimeChanged];
            }
            
            [weakSelf goBack];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"");
    }];
}

//时间格式改变 在主页修改model中date类型 yyyy-MM-dd / MM-dd-yyyy
- (void)dateTypeChanged {
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"dateType"];
    if (![_viewmodel.setmodel.dateType isEqualToString:str]) {
        [[NSUserDefaults standardUserDefaults] setObject:_viewmodel.setmodel.dateType forKey:@"dateType"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dateType" object:nil];
    }
}

//提醒开关 修改本地通知提醒时间/删除通知
- (void)remindtimeChanged {
    if (_viewmodel.setmodel.isOpenRemind) {
        //打开提醒。修改通知时间
        NSString *remindTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"remindTime"];
        if ([_viewmodel.setmodel.remindTime isEqualToString:remindTime]) {
            return;
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:_viewmodel.setmodel.remindTime forKey:@"remindTime"];
            [self addLocalNotificationWithReminTime:remindTime];
        }
    } else {
        //关闭提醒。移除通知
        [[UIApplication sharedApplication] cancelAllLocalNotifications];//移除所有的通知
    }
}

#pragma mark - UI

- (void)initUIView {
    [self setBackButton:YES];
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(0, 0, 50, 40);
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [finishBtn setTitle:@"保存" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor hexStringToColor:@"#333333"] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
    [self addNavigationWithTitle:@"设置" leftItem:nil rightItem:rightItem titleView:nil];
    self.settingTable.tableFooterView = [UIView new];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentRow = indexPath;
    if (indexPath.row == 1){
        SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SwitchTableViewCell" owner:nil options:nil].firstObject;
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *arr = [NSArray arrayWithObjects:@"", @"提醒开关",  @"", @"", nil];
        [cell setTitleWithStr:arr[indexPath.row] isOn:_viewmodel.setmodel.isOpenRemind];
        
        return cell;
    } else {
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:nil options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 4) {
            cell.isHideRight = YES;
        }
        
        NSArray *title = [NSArray arrayWithObjects:@"日期格式", @"", @"提醒时间", @"主题", @"版本", nil];
        NSArray *detail = [NSArray arrayWithArray:_viewmodel.setList];
        [cell setDataWithTitle:title[indexPath.row] detailTitle:detail[indexPath.row]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentRow = indexPath;
    if (indexPath.row == 1 || indexPath.row == 4) {
        [_picker removeFromSuperview];
    } else {
        NSMutableArray *rowsArr = [NSMutableArray array];
        if (indexPath.row == 0) {
            rowsArr = [NSMutableArray arrayWithObjects:@"yyyy-MM-dd", @"MM-dd-yyyy", nil];
        } else if (indexPath.row == 2) {
            for (int i = 0; i < 24; i++) {
                //00:00 01:00 / 10:00 11:00
                NSString *str = [NSString string];
                if (i < 10) {
                    str = [NSString stringWithFormat:@"0%d:00",i];
                } else {
                    str = [NSString stringWithFormat:@"%d:00",i];
                }
                
                [rowsArr addObject:str];
            }
        } else {
            rowsArr = [NSMutableArray arrayWithObjects:@"默认", @"花", @"男孩", @"霉霉", @"柠檬", @"粉红豹", nil];
        }
        
        [self showPicker];
        _picker.rowsArr = rowsArr;
        [_picker showInView];
    }
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
    SettingTableViewCell *setCell = [self.settingTable cellForRowAtIndexPath:_currentRow];
    setCell.detailLab.text = title;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (_currentRow.row == 0) {
        _viewmodel.setmodel.dateType = setCell.detailLab.text;
        [defaults setInteger:row forKey:@"row"];
        
    } else if (_currentRow.row == 2) {
        _viewmodel.setmodel.remindTime = setCell.detailLab.text;
//        [defaults setObject:title forKey:@"remindTime"];
    } else if (_currentRow.row == 3) {
        _viewmodel.setmodel.theme = setCell.detailLab.text;
        [defaults setObject:title forKey:@"themeName"];
    }
}

#pragma mark - SwitchCellDelegate
- (void)isOpenTheSwitch:(BOOL)isOpen {
    //显示图标
    _viewmodel.setmodel.isOpenRemind = isOpen;
    
    NSLog(@"tixing");
}

#pragma mark - LocalNotification

- (void)addLocalNotificationWithReminTime:(NSString *)remindTime {
    remindTime = remindTime == nil ? @"00:00" : remindTime;
    
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:@"list.plist"];
    
    NSMutableArray *dataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    
    for (HomeModel *model in dataArr) {
        NSString *key = model.thingId;
        NSDictionary *dic = [NSDictionary dictionaryWithObject:model.thingId forKey:key];
        NSInteger repeatType;
        if ([model.repeatType isEqualToString:@"无重复"]) {
            repeatType = 0;
        } else if ([model.repeatType isEqualToString:@"每周"]) {
            repeatType = NSCalendarUnitWeekday;
        } else if ([model.repeatType isEqualToString:@"每月"]) {
            repeatType = NSCalendarUnitMonth;
        } else {//每年
            repeatType = NSCalendarUnitYear;
        }
//        NSString *remindTime = [defaults objectForKey:@"remindTime"];
//        NSString *remindTime = @"10";
        [self scheduleLocalNotificationWithModel:model time:remindTime userInfo:dic repeatType:repeatType];
    }
}

- (void)scheduleLocalNotificationWithModel:(HomeModel *)model time:(NSString *)delayTime userInfo:(NSDictionary *)userInfo repeatType:(NSInteger)repeatType {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSDate *fireDate = [formatter dateFromString:delayTime];
    
//    NSInteger time = [delayTime integerValue];
//    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:time];

    localNotification.fireDate = fireDate;//本地通知的触发时间
    localNotification.timeZone = [NSTimeZone defaultTimeZone];//本地通知的时区
    localNotification.repeatInterval = NSCalendarUnitDay;//重复的时间间隔
    localNotification.alertBody = model.title;//通知的内容
    localNotification.alertAction = @"知道啦";//通知动作的按钮 类似提示框的确认取消
    localNotification.applicationIconBadgeNumber = 1;//徽标数
    localNotification.soundName = UILocalNotificationDefaultSoundName;//提示音 可以自己添加声音文件，这里设置为默认提示声
    localNotification.userInfo = userInfo;
    localNotification.repeatInterval = repeatType;
    
    //必须判断 注册 通知才能发送成功
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        NSLog(@"111");
        
        //注册通知
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |  UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        NSLog(@"000");
    }
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"通知成功");
}

//添加
/*
 在新建移除再添加，
 */

//移除
- (void)removewLocalNotification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)removeLocalAllNotifications {
    NSArray *localNotis = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!localNotis || localNotis.count <= 0) {
        return;
    }
    for (UILocalNotification *noti in localNotis) {
        if ([[noti.userInfo objectForKey:@"id"] isEqualToString:@"local_id"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];//取消某个通知
            break;
        }
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//移除所有的通知
    
}

@end
