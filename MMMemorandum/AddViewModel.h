//
//  AddViewModel.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddViewModel : NSObject

@property (nonatomic, strong) HomeModel *home;
@property (nonatomic, strong) NSMutableArray *homeListArr;

//保存数据
- (void)saveDataWithModel:(HomeModel *)model success:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure;

//删除数据
- (void)deleteDataWithModel:(HomeModel *)model success:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure;

@end
