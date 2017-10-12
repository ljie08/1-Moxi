//
//  DateView.h
//  ChooseTime
//
//  Created by ljie on 16/4/22.
//  Copyright © 2016年 与日月兮同光🌞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewDelegate <NSObject>

- (void)dateForRow:(NSString *)dateStr;//将选中行的title传给控制器

- (void)datePickerWillHide;

@end

@interface DateView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, assign) id <DateViewDelegate> delegate;

-(void)showDateView;

@end

