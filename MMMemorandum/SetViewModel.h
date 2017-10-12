//
//  SetViewModel.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/21.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetViewModel : NSObject

@property (nonatomic, strong) SetModel *setmodel;
@property (nonatomic, strong) NSMutableArray *setList;

//展示数据
- (void)showDatasetDataSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure;

//保存数据
- (void)setDataSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure;

@end
