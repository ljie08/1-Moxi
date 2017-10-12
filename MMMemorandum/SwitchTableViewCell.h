//
//  SwitchTableViewCell.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchCellDelegate <NSObject>

- (void)isOpenTheSwitch:(BOOL)isOpen;

@end

@interface SwitchTableViewCell : UITableViewCell

@property (nonatomic, assign) id <SwitchCellDelegate> delegate;

- (void)setTitleWithStr:(NSString *)title isOn:(BOOL)isOn;

@end
