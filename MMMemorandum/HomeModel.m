//
//  HomeModel.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "HomeModel.h"
#import "MJExtension.h"

@implementation HomeModel

//使用MJExtension归档，只需这一个宏定义，省去了下边这些代码，简单方便
MJCodingImplementation

//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    if (self == [super init]) {
////        self.title = [aCoder decodeObjectForKey:@"title"];
////        self.date = [aCoder decodeObjectForKey:@"date"];
////        self.overdue = [aCoder decodeObjectForKey:@"overdue"];
////        self.day = [aCoder decodeObjectForKey:@"day"];
////        self.isTop = [aCoder decodeObjectForKey:@"isTop"];
////        self.repeatType = [aCoder decodeObjectForKey:@"repeatType"];
//        
//        [aCoder encodeObject:self.title forKey:@"title"];
//        [aCoder encodeObject:self.date forKey:@"date"];
//        [aCoder encodeObject:self.overdue forKey:@"overdue"];
//        [aCoder encodeObject:self.day forKey:@"day"];
//        [aCoder encodeObject:[NSNumber numberWithInt:self.isTop] forKey:@"isTop"];
////        [aCoder encodeObject:self.isTop forKey:@"isTop"];
//        [aCoder encodeObject:self.repeatType forKey:@"repeatType"];
//    }
//}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self == [super init]) {
//        self.title = [aDecoder decodeObjectForKey:@"title"];
//        self.date = [aDecoder decodeObjectForKey:@"date"];
//        self.overdue = [aDecoder decodeObjectForKey:@"overdue"];
//        self.day = [aDecoder decodeObjectForKey:@"day"];
//        NSNumber *istop = [aDecoder decodeObjectForKey:@"isTop"];
//        self.isTop = istop;
////        self.isTop = [aDecoder decodeObjectForKey:@"isTop"];
//        self.repeatType = [aDecoder decodeObjectForKey:@"repeatType"];
//    }
//    return self;
//}

@end
