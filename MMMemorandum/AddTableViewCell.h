//
//  AddTableViewCell.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^TextFieldBlock)(NSString *text);

@protocol TFDelegate <NSObject>

- (void)finishedWithText:(NSString *)text;

@end

@interface AddTableViewCell : UITableViewCell

@property (nonatomic, assign) id <TFDelegate> delegate;

//@property (nonatomic, copy) TextFieldBlock tfBlock;
- (void)setDataWithTitle:(NSString *)title tfText:(NSString *)tfText;

@end
