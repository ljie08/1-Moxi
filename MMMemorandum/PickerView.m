//
//  PickerView.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "PickerView.h"

@interface PickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;//放button和picker的view
@property (weak, nonatomic) IBOutlet UIPickerView *durationPicker;//选择view
@property (nonatomic, assign) NSInteger row;

@end

@implementation PickerView

- (NSMutableArray *)rowsArr {
    if (_rowsArr == nil) {
        _rowsArr = [NSMutableArray array];
    }
    return _rowsArr;
}

- (void)showInView{
    self.durationPicker.delegate = self;
    self.durationPicker.dataSource = self;
    [self.durationPicker reloadComponent:0];
    self.frame = CGRectMake(0, Screen_Height, Screen_Width, self.frame.size.height);
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    [self addGestureRecognizer:tap];
    
    [CurrentKeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, Screen_Height - self.frame.size.height, Screen_Width, self.frame.size.height);
    }];
    [self pickerView:self.durationPicker didSelectRow:0 inComponent:0];//实现默认选中第一行的点击方法，将第一行的title传给控制器
}

- (void)removeView:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    BOOL hasPoint = CGRectContainsPoint(self.bgView.frame, point);
    if (!hasPoint) {//点击bgView以外的点让picker消失
        [self removePicker];
    }
}

- (void)removePicker {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, Screen_Height, Screen_Width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.rowsArr removeAllObjects];
    }];
}

- (IBAction)sureClicked:(id)sender {
    [self removePicker];
    if ([self.delegate respondsToSelector:@selector(title:row:)]) {
        [self.delegate title:self.rowTitle row:self.row];
    }
}

- (IBAction)cancelClicked:(id)sender {
    [self removePicker];
}

#pragma mark - pickerview
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;// 返回列数
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.rowsArr.count;//返回行数
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.rowsArr objectAtIndex:row];//返回每行的标题
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.rowTitle = [self.rowsArr objectAtIndex:row];
    self.row = row;
}

@end
