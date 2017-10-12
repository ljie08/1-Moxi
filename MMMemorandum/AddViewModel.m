//
//  AddViewModel.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "AddViewModel.h"

@implementation AddViewModel

- (instancetype)init {
    if (self = [super init]) {
        _home = [[HomeModel alloc] init];
        _homeListArr = [NSMutableArray array];
    }
    return self;
}

- (void)saveDataWithModel:(HomeModel *)model success:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure {
    NSLog(@"------");
    
    //每次保存的时候先将数组置为本地存储的数组，以防每次新建完返回home，再新建的时候，数组已经初始化为nil，所以每次数组都是一个model
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:@"list.plist"];
    self.homeListArr = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    if (self.homeListArr == nil) {
        self.homeListArr = [NSMutableArray new];
    }
    self.home.thingId = self.home.thingId == nil ? [NSDate getNowDateString] : self.home.thingId;
    
    if (model != nil) {//修改
        for (HomeModel *hm in self.homeListArr) {
            if ([hm.thingId isEqualToString:model.thingId]) {
                hm.title = self.home.title==nil?hm.title:self.home.title;
                hm.date = self.home.date==nil?hm.date:self.home.date;
                hm.overdue = self.home.overdue==nil?hm.overdue:self.home.overdue;
                hm.day = self.home.day==nil?hm.day:self.home.day;
                hm.isTop = self.home.isTop;
                hm.repeatType = self.home.repeatType==nil?hm.repeatType:self.home.repeatType;
                self.home = hm;
            }
            [self getTime];
        }
        //将修改了model的数组归档 存到本地
        [NSKeyedArchiver archiveRootObject:self.homeListArr toFile:listPath];
    } else {//新建
        [self getTime];
        //将model存入数组
        if (self.home.isTop) {
            [self.homeListArr insertObject:self.home atIndex:0];
        } else {
            [self.homeListArr addObject:self.home];
        }
        
        //将添加了model的数组归档 存到本地
        [NSKeyedArchiver archiveRootObject:self.homeListArr toFile:listPath];
    }
    NSLog(@"homelist count -> %ld", self.homeListArr.count);
    
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    NSLog(@"%@",arr);
    
    success(YES);
}

//删除数据
- (void)deleteDataWithModel:(HomeModel *)model success:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure {
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:@"list.plist"];
    self.homeListArr = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.homeListArr];
    for (HomeModel *homeM in self.homeListArr) {
        //遍历的时候，被遍历的内容不能被修改，会crash，所以修改新数组
        if ([homeM.thingId isEqualToString:model.thingId]) {
            
            [newArr removeObject:homeM];
        }
    }
    
    //将修改后的数组重新归档
    [NSKeyedArchiver archiveRootObject:newArr toFile:listPath];
    
    success(YES);
}

- (void)getTime {
    //计算时间差
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *dateType = [defaults objectForKey:@"dateType"] == nil ? @"yyyy-MM-dd" : [defaults objectForKey:@"dateType"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateType];//计算的两个时间的时间格式要统一
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    NSDate *date = [formatter dateFromString:self.home.date];
    
    NSInteger day = [NSDate getDaysFromNowToEnd:date];
    NSString *dayStr = [NSString stringWithFormat:@"%ld", day];
    dayStr = day < 0 ? [dayStr stringByReplacingOccurrencesOfString:@"-" withString:@""] : dayStr;
    self.home.overdue = day < 0 ? @"已过" : @"还有";
    
    self.home.day = dayStr;
}


@end
