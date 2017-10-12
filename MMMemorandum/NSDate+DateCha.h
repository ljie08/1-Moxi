//
//  NSDate+DateCha.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/25.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateCha)

//计算两个日期之间的天数
+ (NSInteger)getDaysFromNowToEnd:(NSDate *)endDate;
//获取当前时间字符串
+ (NSString *)getNowDateString;

@end
