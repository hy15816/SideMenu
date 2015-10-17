//
//  ViewController.m
//  hiu
//
//  Created by AEF-RD-1 on 15/9/30.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#define hHYTabBarHeight 49

#import "RootViewController.h"
#import "UIViewController+sideMenu.h"
#import "FirstVC.h"
#import "SecondVC.h"
#import "ThirdVC.h"
#import "HYNavVC.h"
#import "SettingsVC.h"

@interface RootViewController ()<UINavigationControllerDelegate>
{
    UIViewController *currentVC;
}
@property (strong,nonatomic) UISegmentedControl *segmentControl;
@property (strong,nonatomic) UITableView *tableViewf;
@property (strong,nonatomic) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *imgArray;

@end

@implementation RootViewController
@synthesize isPushIndex;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //VC跳转
    if (isPushIndex < 1) return;
    [self jumpToVC];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildControllers];
    [self addTabBarItem];
        
}

#pragma mark -- 页面跳转
- (void)jumpToVC{
    
    UIViewController *controller;
    switch (isPushIndex) {
        case 1:
            controller = [[UIViewController alloc] init];
            controller.view.backgroundColor = [UIColor yellowColor];
            controller.title = @"first";
            break;
        case 2:
            controller = [kLeftStoryboard instantiateViewControllerWithIdentifier:@"QRCodeVCIDF"];
            break;
        case 3:
            controller = [[UIViewController alloc] init];
            controller.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
            controller.title = @"third";
            break;
        case 4:
            controller = [kMainStoryboard instantiateViewControllerWithIdentifier:@"SettingsVCIDF"];
            break;
        case kTAG_USER_ICON:
            controller = [kLeftStoryboard instantiateViewControllerWithIdentifier:@"UserInfoEditIDF"];
            break;
        default:
            break;
    }
    [currentVC.navigationController pushViewController:controller animated:YES];
    //[self.navigationController pushViewController:controller animated:YES];
    //[self presentViewController:navc animated:YES completion:^{}];
    //这里应该是由nav push的，但是没有nav，
    //可否让first、second、third等vc去push呢？
    //是否在此时加上nav，当子vc返回时，就隐藏这个nav
    //怎么知道子vc返回了？
}

//tabBar的item
-(void)addTabBarItem{
    
    [hyTabBar addItemIcon:@"ooopic_11" select:@"ooopic_15" title:@"首页" selectTitlt:@"T_T"];
    [hyTabBar addItemIcon:@"ooopic_12" select:@"ooopic_15" title:@"发现" selectTitlt:@"T_T"];
    [hyTabBar addItemIcon:@"ooopic_13" select:@"ooopic_15" title:@"我的" selectTitlt:@"T_T"];
    
}

//添加子控制器
-(void)addChildControllers{
    //
    FirstVC *first = [[FirstVC alloc] init];
    HYNavVC *nav1 = [[HYNavVC alloc] initWithRootViewController:first];
    nav1.delegate = self;
    
    //
    SecondVC *sec = [[SecondVC alloc] init];
    //sec.delegate = self;
    HYNavVC *nav2 = [[HYNavVC alloc] initWithRootViewController:sec];
    nav2.delegate = self;
    
    //
    ThirdVC *third = [[ThirdVC alloc] init];
    HYNavVC *nav3 = [[HYNavVC alloc] initWithRootViewController:third];
    nav3.delegate = self;
    
    currentVC = first;
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:nav3];
    
}

#pragma mark -- UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    hyTabBar.hidden = NO;
    
    // 获得当期导航控制器的根控制器
    UIViewController *root = navigationController.viewControllers[0];
    if (root != viewController) { // 不是根控制器
        // 拉长导航控制器的view
        CGRect frame = navigationController.view.frame;
        frame.size.height = [UIScreen mainScreen].applicationFrame.size.height+20;
        navigationController.view.frame = frame;
        
        // 添加Dock到根控制器的view上面
        [hyTabBar removeFromSuperview];
        CGRect dockFrame = hyTabBar.frame;
        
        dockFrame.origin.y = root.view.frame.size.height - hHYTabBarHeight;
        
        if ([root.view isKindOfClass:[UIScrollView class]]) { // 根控制器的view是能滚动
            UIScrollView *scroll = (UIScrollView *)root.view;
            dockFrame.origin.y += scroll.contentOffset.y;
            
        }
        hyTabBar.frame = dockFrame;
        [root.view addSubview:hyTabBar];
    }
    
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    UIViewController *root = navigationController.viewControllers[0];
    if (viewController == root) {
        // 让导航控制器view的高度还原
        CGRect frame = navigationController.view.frame;
        frame.size.height = [UIScreen mainScreen].applicationFrame.size.height - hHYTabBarHeight+20;
        navigationController.view.frame = frame;
        
        // 添加Dock到mainView上面
        [hyTabBar removeFromSuperview];
        CGRect dockFrame = hyTabBar.frame;
        //dockFrame = CGRectMake(0, self.view.frame.size.height - kDockHeight-23, self.view.frame.size.width, kDockHeight);
        
        // 调整dock的y值
        dockFrame.origin.y = self.view.frame.size.height - hHYTabBarHeight;
        hyTabBar.frame = dockFrame;
        [self.view addSubview:hyTabBar];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
