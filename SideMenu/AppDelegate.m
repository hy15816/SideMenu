//
//  AppDelegate.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/10.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LeftMenuViewController.h"
#import "RESideMenu.h"
#import "HYNavVC.h"
#import "AFNetworking/AFNetworking.h"
#import "APService.h"

@interface AppDelegate ()<RESideMenuDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RootViewController *rootVC = [[RootViewController alloc] init];
    //HYNavVC *navigationController = [[HYNavVC alloc] initWithRootViewController:[[RootViewController alloc] init]];
    LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc] init];
    //DEMORightMenuViewController *rightMenuViewController = [[DEMORightMenuViewController alloc] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:rootVC leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
    
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];
    
    [self changedNavBar];
    [self monitoringNetwork];
    [self registJPush:launchOptions];
    return YES;
}

#pragma mark - Change导航栏属性
-(void)changedNavBar{
    //背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bg_v"] forBarMetrics:UIBarMetricsDefault];
    //修改导航栏标题的字体
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    shadow.shadowOffset = CGSizeMake(0, 0);
    //标题字体
    [[UINavigationBar appearance] setTitleTextAttributes:  [NSDictionary dictionaryWithObjectsAndKeys:                                                         [UIColor whiteColor], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"Arial-BoldMT" size:20.0], NSFontAttributeName, nil]];
    //设置back按钮字体颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
}

/**
 *  监测网络
 */
- (void)monitoringNetwork{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
       
        NSLog(@"net work status:%ld",(long)status);
    }];
}

#pragma mark - RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

#pragma mark - UIApplicationDelegate
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -- APService & UIApplicationDelegate
//注册通知
- (void)registJPush:(NSDictionary *)launchOptions{
    // Required
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
    // set debug mode
    [APService setDebugMode];
    
    // Required
    [APService setupWithOption:launchOptions];
}

//向苹果的服务器 提交deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // Required
    [APService registerDeviceToken:deviceToken];
    NSLog(@"deviceToken:%@",deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@",error);
}

//接收推送的消息
//一、后台：
    //1）不在程序里面时,有声音等提示，进入此方法
    //2）在程序运行前端时,没有提示，但也会进入此方法
//二、已完全退出程序
    //会执行方法 application:didFinishLaunchingWithOptions,在这里可以获取推送来的消息的内容
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
    /*
    //判断前后台运行
    if ([application applicationState] == UIApplicationStateActive) {
        //当前前台运行
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到通知" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"sure", nil];
        [alert show];
    }else if ([application applicationState] == UIApplicationStateBackground){
        //后台
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowRemoteNotification object:nil userInfo:userInfo];
    }
     */
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowRemoteNotification object:nil userInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
