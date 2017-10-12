//
//  NSDate+DateCha.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/25.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "NSDate+DateCha.h"

@implementation NSDate (DateCha)

//计算两个日期之间的天数
+ (NSInteger)getDaysFromNowToEnd:(NSDate *)endDate {
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *beginDate = [NSDate date];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    int a = ((int)time)%(3600*24);
    if (a == 0) {
        return days;//只取到天数
    } else {
        if (a > 0) {//未来
            return days+1;
        } else {//过去
            return days;
        }
    }
}

//获取当前时间字符串
+ (NSString *)getNowDateString {
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    NSLog(@"%@", timeString);
    return timeString;
}

@end
