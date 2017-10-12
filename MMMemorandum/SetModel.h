//
//  SetModel.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/21.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetModel : NSObject

@property (nonatomic, copy) NSString *dateType;//日期格式
@property (nonatomic, assign) BOOL isOpenRemind;//是否打开提醒
@property (nonatomic, copy) NSString *remindTime;//提醒时间
@property (nonatomic, copy) NSString *theme;//主题
@property (nonatomic, copy) NSString *version;//版本

@end
