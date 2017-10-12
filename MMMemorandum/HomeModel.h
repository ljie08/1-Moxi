//
//  HomeModel.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *thingId;//事件id
@property (nonatomic, copy) NSString *title;//事件标题
@property (nonatomic, copy) NSString *date;//日期
@property (nonatomic, copy) NSString *overdue;//未来/过去 是否过期 还有（未来）多少天/已经过了（过去）多少天
@property (nonatomic, copy) NSString *day;//天数
@property (nonatomic, assign) BOOL isTop;//是否置顶
@property (nonatomic, copy) NSString *repeatType;//重复类型 无重复、每周、每月、每年

@end
