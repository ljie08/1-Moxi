//
//  SetViewModel.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/21.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "SetViewModel.h"

@implementation SetViewModel

- (instancetype)init {
    if (self = [super init]) {
        _setmodel = [[SetModel alloc] init];
        _setList = [NSMutableArray array];
    }
    
    return self;
}

- (void)showDatasetDataSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure {
    NSString *modelFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *modelPath = [modelFile stringByAppendingPathComponent:@"set.plist"];
    //如果不判断是否为nil，第一次使用app的时候，本地数据为nil，赋值后model也为nil。下边setData里model也会是nil
    self.setmodel = [NSKeyedUnarchiver unarchiveObjectWithFile:modelPath] == nil ? self.setmodel : [NSKeyedUnarchiver unarchiveObjectWithFile:modelPath];
    
    [self.setList addObject:self.setmodel.dateType == nil ? @"yyyy-MM-dd" : self.setmodel.dateType];
    [self.setList addObject:[NSNumber numberWithBool:self.setmodel == nil ? NO : self.setmodel.isOpenRemind]];
    [self.setList addObject:self.setmodel.remindTime == nil ? @"00:00" : self.setmodel.remindTime];
    [self.setList addObject:self.setmodel.theme == nil ? @"默认" : self.setmodel.theme];
    [self.setList addObject:self.setmodel.version == nil ? @"1.0" : self.setmodel.version];
    
    success(YES);
}

- (void)setDataSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure {
    //将model归档
    self.setmodel.version = @"V1.0.0";
    self.setmodel.dateType = self.setmodel.dateType == nil ? @"yyyy-MM-dd" : self.setmodel.dateType;
    self.setmodel.remindTime = self.setmodel.remindTime == nil ? @"00:00" : self.setmodel.remindTime;
    self.setmodel.theme = self.setmodel.theme == nil ? @"默认" : self.setmodel.theme;
    
    NSString *modelFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *modelPath = [modelFile stringByAppendingPathComponent:@"set.plist"];
    [NSKeyedArchiver archiveRootObject:self.setmodel toFile:modelPath];
    
    SetModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:modelPath];
    NSLog(@"%@", model);
    NSLog(@"%@", self.setmodel);
    
    success(YES);
}

@end
