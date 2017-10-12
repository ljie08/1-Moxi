//
//  BaseViewController.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/18.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"默认"]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setThemeImgWithPicture:) name:@"change" object:nil];
    
    [self initViewModelBinding];
    [self initUIView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *themeName = [defaults objectForKey:@"themeName"];
    [self setThemeImgWithPicture:themeName];
    NSLog(@"themeName -> %@", themeName);
}

#pragma mark - 页面UI初始化搭建
- (void)initUIView {
}

#pragma mark - 设置背景图
- (void)setThemeImgWithPicture:(NSString *)name {
    UIImage *image = [[UIImage alloc] init];
    if (name == nil) {
        image = [UIImage imageNamed:@"默认"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    } else {
        image = [UIImage imageNamed:name];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:name]];
    }
    self.view.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
}

#pragma mark - 创建ViewModel，viewModel的参数初始化工作等

- (void)initViewModelBinding {
    
}

/**
 * @brief  设置导航的标题 左右item
 *
 * @param
 *
 * @return
 */

/**
 设置导航栏

 @param title 标题
 @param left 左item
 @param right 右item
 @param view 标题view
 */
- (void)addNavigationWithTitle:(NSString *)title leftItem:(UIBarButtonItem  *)left rightItem:(UIBarButtonItem *)right titleView:(UIView *)view {
    if (title) {
        // 设置导航的标题
        self.navigationItem.title = title;
    }
    
    if (left) {
        // 设置左边的item
        self.navigationItem.leftBarButtonItem = left;
    }
    
    if (right) {
        // 设置右边的item
        self.navigationItem.rightBarButtonItem = right;
    }
    
    if (view) {
        // 设置标题view
        self.navigationItem.titleView = view;
    }
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@""];
}

//设置返回按钮是否显示
- (void)setBackButton:(BOOL)isShown {
    if (isShown) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 12, 18);
        [backBtn setImage:[UIImage imageNamed:@"black_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        self.navigationItem.leftBarButtonItem = leftItem;//[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

//返回
- (void)goBack {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

//返回到根视图控制器
- (void)goRootBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
