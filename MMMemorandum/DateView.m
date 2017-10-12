//
//  DateView.m
//  ChooseTime
//
//  Created by ljie on 16/4/22.
//  Copyright © 2016年 与日月兮同光🌞. All rights reserved.
//

#import "DateView.h"

@interface DateView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *timeStr;

@end

@implementation DateView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)cancelClicked:(id)sender {
    [self removePicker];
}

- (IBAction)sureClicked:(id)sender {
    [self removePicker];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *dateType = [defaults objectForKey:@"dateType"] == nil ? @"yyyy-MM-dd" : [defaults objectForKey:@"dateType"];
    
    //当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateType;
    NSString *nowStr = [formatter stringFromDate:[NSDate date]];
    //datePicker选中的时间
    NSDate *pickerDate = self.datePicker.date;
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
    [pickerFormatter setDateFormat:dateType];
    NSString *pickerStr = [NSString stringWithFormat:@"%@", [pickerFormatter stringFromDate:pickerDate]];
    //datePicker默认选中的时间是当前时间，如果当前选中的时间是当前时间（datePicker没改变value），将默认选中的时间传给label显示，否则将选中的时间传出去（datePicker有改变value）
    if ([self.delegate respondsToSelector:@selector(dateForRow:)]) {
        if ([pickerStr isEqualToString:nowStr]) {
            [self.delegate dateForRow:nowStr];
        } else {
            [self.delegate dateForRow:self.timeStr];
        }
    }
}

-(void)showDateView {
    self.frame = CGRectMake(0, Screen_Height, Screen_Width, self.frame.size.height);
    self.userInteractionEnabled = YES;
    [self.bgView setNeedsLayout];
    [self.bgView layoutIfNeeded];//获取xib中控件的frame
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    [self addGestureRecognizer:tap];
    
    [CurrentKeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, Screen_Height - self.frame.size.height, Screen_Width, self.frame.size.height);
    }];
    
    [self.datePicker addTarget:self action:@selector(changed:) forControlEvents:UIControlEventValueChanged];
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
    }];
    if ([self.delegate respondsToSelector:@selector(datePickerWillHide)]) {
        [self.delegate datePickerWillHide];//picker将要隐藏，view恢复到原来的位置
    }
}

-(void)changed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *dateType = [defaults objectForKey:@"dateType"] == nil ? @"yyyy-MM-dd" : [defaults objectForKey:@"dateType"];
    
    UIDatePicker *control = (UIDatePicker *)sender;
    NSDate *date = control.date;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:dateType];
    self.timeStr = [dateformatter stringFromDate:date];
}

@end
