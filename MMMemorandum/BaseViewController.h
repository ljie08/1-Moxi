//
//  BaseViewController.h
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 设置背景图

 @param pictureName 图片名
 */
- (void)setThemeImgWithPicture:(NSString *)pictureName;

/**
 *  是否显示返回按钮
 *
 *  isShown
 */
- (void)setBackButton:(BOOL)isShown;

/**
 *  创建UI
 */
- (void)initUIView;

/**
 *  绑定viewModel
 */
- (void)initViewModelBinding;

/**
 设置导航栏
 */
- (void)addNavigationWithTitle:(NSString *)title leftItem:(UIBarButtonItem  *)left rightItem:(UIBarButtonItem *)right titleView:(UIView *)view;

/**
 *  返回，默认情况下为navigationController的弹出
 */
- (void)goBack;

//返回到根视图控制器
- (void)goRootBack;

@end
