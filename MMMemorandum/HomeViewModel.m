//
//  HomeViewModel.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/20.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        _home = [[HomeModel alloc] init];
        _homeListArr = [NSMutableArray array];
    }
    
    return self;
}

- (void)getHomeDataIsChanged:(BOOL)isChanged success:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure {
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:@"list.plist"];
    
    self.homeListArr = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    
    NSLog(@"arr count -- %ld", self.homeListArr.count);
    
    for (HomeModel *model in self.homeListArr) {
        [self getTimeWithModel:model];
        //把yyyy-MM-dd格式的model.date字符串转换成yyyy-MM-dd格式的date
        //把yyyy-MM-dd格式的date转成MM-dd-yyyy格式的date
        //把MM-dd-yyyy格式的date转成MM-dd-yyyy格式的字符串
        if (isChanged) {
            [self setModelDateTypeWithModel:model];
        }
    }
    
    [NSKeyedArchiver archiveRootObject:self.homeListArr toFile:listPath];
    
    success(YES);
}

//设置model里的时间格式
- (void)setModelDateTypeWithModel:(HomeModel *)model {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"dateType"];
    NSString *dateType = str == nil ? @"yyyy-MM-dd" : str;
    
    NSDate *xDate = [NSDate date];

    if ([dateType isEqualToString:@"yyyy-MM-dd"]) {//如果本来是MM-dd-yyyy，设置成了yyyy-MM-dd
        //dateType为yyyy-MM-dd model为MM-dd-yyyy
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"MM-dd-yyyy";
        xDate = [formatter1 dateFromString:model.date];
        formatter1.dateFormat = @"yyyy-MM-dd";
        NSString *xStr = [formatter1 stringFromDate:xDate];
        NSLog(@"%@", xStr);
        model.date = [formatter1 stringFromDate:xDate];
    } else {//本来是yyyy-MM-dd，设置成了MM-dd-yyyy
        //dateType为MM-dd-yyyy，model为yyyy-MM-dd
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"yyyy-MM-dd";
        xDate = [formatter2 dateFromString:model.date];
        formatter2.dateFormat = @"MM-dd-yyyy";
        NSString *xStr = [formatter2 stringFromDate:xDate];
        NSLog(@"%@", xStr);
        model.date = [formatter2 stringFromDate:xDate];
    }
}

- (void)getTimeWithModel:(HomeModel *)model {
    //计算时间差
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *dateType = [defaults objectForKey:@"dateType"] == nil ? @"yyyy-MM-dd" : [defaults objectForKey:@"dateType"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateType];//计算的两个时间的时间格式要统一
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    NSDate *date = [formatter dateFromString:model.date];
    
    NSInteger day = [NSDate getDaysFromNowToEnd:date];
    NSString *dayStr = [NSString stringWithFormat:@"%ld", day];
    dayStr = day < 0 ? [dayStr stringByReplacingOccurrencesOfString:@"-" withString:@""] : dayStr;
    model.overdue = day < 0 ? @"已过" : @"还有";
    
    model.day = dayStr;
}


@end
