//
//  HomeViewModel.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/20.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

@property (nonatomic, strong) HomeModel *home;
@property (nonatomic, strong) NSMutableArray *homeListArr;

//获取数据
- (void)getHomeDataIsChanged:(BOOL)isChanged success:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure;

@end
