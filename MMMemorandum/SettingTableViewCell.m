//
//  SettingTableViewCell.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell (){
    
}
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题

@property (weak, nonatomic) IBOutlet UIImageView *rightImg;//右箭头
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightPadding;//详细距右边距离

@end
@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithTitle:(NSString *)title detailTitle:(NSString *)detail {
    self.titleLab.text = title;
    self.detailLab.text = detail;
    if (self.isHideRight) {
        self.rightImg.hidden = YES;
        self.rightPadding.constant = 15.0;
    }
}

- (void)setDataWithTitle:(NSString *)title model:(SetModel *)model {
    self.titleLab.text = title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
