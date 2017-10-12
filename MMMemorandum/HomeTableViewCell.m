//
//  HomeTableViewCell.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *dateLab;//目标日
@property (weak, nonatomic) IBOutlet UILabel *overdueLab;//是否过期 还有（未来）多少天/已经过了（过去）多少天
@property (weak, nonatomic) IBOutlet UILabel *dayLab;//天数

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithModel:(HomeModel *)model {
    self.titleLab.text = model.title;
    self.dateLab.text = model.date;
    self.overdueLab.text = model.overdue;
    self.dayLab.text = model.day;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
