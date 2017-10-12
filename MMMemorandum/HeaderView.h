//
//  HeaderView.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderDelegate <NSObject>

//- (void)pushVCWithTag:(NSInteger)tag;
//- (void)showList;

@end

@interface HeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dayLab;//天数

@property (nonatomic, assign) id <HeaderDelegate> delegate;

- (void)setDataWithModel:(HomeModel *)model;

@end
