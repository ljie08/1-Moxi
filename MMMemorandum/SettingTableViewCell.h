//
//  SettingTableViewCell.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailLab;//详细
@property (nonatomic, assign) BOOL isHideRight;

- (void)setDataWithTitle:(NSString *)title detailTitle:(NSString *)detail;
- (void)setDataWithTitle:(NSString *)title model:(SetModel *)model;

@end
