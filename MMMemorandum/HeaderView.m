//
//  HeaderView.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *overdueLab;//已过/还有
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *dateLab;//日期
@property (weak, nonatomic) IBOutlet UILabel *dLab;//天

@property (nonatomic, strong) NSTimer *dayAnimationTimer;

@end

@implementation HeaderView

- (void)setDataWithModel:(HomeModel *)model {
    self.overdueLab.text = model.overdue;
    self.dayLab.text = model.day;
    self.titleLab.text = model.title;
    self.dateLab.text = model.date;
    self.dLab.text = model == nil ? @"" : @"天";
    
    [self setDayOfLabel:self.dayLab WithAnimationForValueContent:[model.day floatValue]];
}


- (void)setDayOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value {
    CGFloat lastValue = [label.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) {
        return;
    }
    if (delta > 0) {
        
        CGFloat ratio = value / 30.0;
        
        NSDictionary *userInfo = @{@"label" : label,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        self.dayAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.dayAnimationTimer forMode:NSRunLoopCommonModes];
    }
}
- (void)setupLabel:(NSTimer *)timer {
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 50)) {
        label.text = [NSString stringWithFormat:@"%f", value];
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%f", resValue];
    }
    flag++;
}


@end
