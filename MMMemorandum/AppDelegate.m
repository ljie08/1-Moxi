//
//  AppDelegate.m
//  MMMemorandum
//
//  Created by lijie on 2017/7/17.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    UINavigationController *niv = [[UINavigationController alloc] initWithRootViewController:homeVc];
    self.window.rootViewController = niv;
    
#pragma mark - 本地通知
    //ios 10
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge |UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"successed");
        } else {
            NSLog(@"failure");
        }
    }];
    
//    usernotification
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ios 10 UNUserNotificationCenter

//程序在前台的时候调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    //当程序在前台的时候收到了通知处理方法：
    completionHandler(UNNotificationPresentationOptionNone);//不提示
//    completionHandler(UNNotificationPresentationOptionAlert);//alert提示
//    completionHandler(UNNotificationPresentationOptionBadge);//徽章提示
//    completionHandler(UNNotificationPresentationOptionSound);//声音提示
}

//用户点击通知进入程序，通知消失，或者用户处理了通知action事件时调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSString *actionID = response.actionIdentifier;
    if (actionID) {
        if ([actionID isEqualToString:@"actionIDA"]) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        } else if ([actionID isEqualToString:@"actionIDB"]) {
            
        }
    }
    
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        NSString *userStr = [(UNTextInputNotificationResponse *)response userText];
        if (userStr) {
            NSLog(@"%@", userStr);
        }
    }
    
    completionHandler();
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //程序在运行中，设备不会受到提醒，但是会走这个方法
    //如果要实现程序在后台时候有提醒，如下
    //如果在后台时，点击提醒进入了程序，也会执行本地通知的回调方法，这种情况下用下面的代码，会连续提示两次
    //所以要判断下程序当前的运行状态
    if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@""]) {
        if (application.applicationState == UIApplicationStateActive) {//如果程序的运行状态是激活状态则提醒
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test" message:notification.alertBody delegate:nil cancelButtonTitle:@"close" otherButtonTitles:notification.alertAction, nil];
            [alert show];
        }
    }
}


@end
