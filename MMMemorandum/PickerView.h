//
//  PickerView.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>

- (void)title:(NSString *)title row:(NSInteger)row;

@end

@interface PickerView : UIView

@property (nonatomic, strong) NSString *rowTitle;//选中的行的title

@property (nonatomic, strong) NSMutableArray *rowsArr;//picker行数

@property (nonatomic, assign) id <PickerViewDelegate> delegate;

//加载到view上
- (void)showInView;

@end
