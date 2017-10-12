//
//  SwitchTableViewCell.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "SwitchTableViewCell.h"

@interface SwitchTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitchBtn;

@end

@implementation SwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setTitleWithStr:(NSString *)title isOn:(BOOL)isOn {
    self.titleLab.text = title;
    self.mySwitchBtn.on = isOn;
}

- (IBAction)openOrOff:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(isOpenTheSwitch:)]) {
        [self.delegate isOpenTheSwitch:sender.on];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
