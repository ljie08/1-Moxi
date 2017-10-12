//
//  Header.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/19.
//  Copyright © 2017年 lijie. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define ScreenBounds [[UIScreen mainScreen] bounds]     //屏幕frame
#define Screen_Height [[UIScreen mainScreen] bounds].size.height //屏幕高度
#define Screen_Width [[UIScreen mainScreen] bounds].size.width   //屏幕宽度
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)] //颜色
//当前的windows
#define CurrentKeyWindow [UIApplication sharedApplication].keyWindow
#define weakSelf(self) autoreleasepool{} __weak typeof(self) weak##Self = self;//定义弱引用

#define DateType @"yyyy-MM-dd" //日期格式

#endif /* Header_h */
