//
//  AddTableViewCell.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "AddTableViewCell.h"

@interface AddTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UITextField *nameTF;//事件名

@end

@implementation AddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataWithTitle:(NSString *)title tfText:(NSString *)tfText{
    self.titleLab.text = title;
    self.nameTF.text = tfText;
    self.nameTF.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"begin");
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (self.tfBlock) {
//        self.tfBlock(textField.text);
//    }
    NSLog(@"end");
    if ([self.delegate respondsToSelector:@selector(finishedWithText:)]) {
        [self.delegate finishedWithText:textField.text];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
