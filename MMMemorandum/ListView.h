//
//  ListView.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlockType) (NSInteger tag);

@interface ListView : UIView

//创建选择视图
- (void)showList;

@property (nonatomic) NSArray *strArray;

@property (nonatomic,copy) ActionBlockType actionBlock;

@property (nonatomic) BOOL isSelected;

@property (nonatomic) NSMutableArray *imageArray;

@property (nonatomic) NSInteger number;

@end
