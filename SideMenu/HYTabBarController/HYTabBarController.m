//
//  HYTabBarController.m
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/10.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

#import "HYTabBarController.h"

@interface HYTabBarController ()<HYTabBarViewDelegate>

@end

@implementation HYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addTabBarView];
}
-(void)addTabBarView{
    
    HYTabBarView *tabBarView = [[HYTabBarView alloc] init];
    tabBarView.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
    tabBarView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tabBarView.delegate = self;
    [self.view addSubview:tabBarView];
    hyTabBar = tabBarView;

}

#pragma mark - HYTabBarViewDelegate

-(void)tabBarView:(HYTabBarView *)barView fromItem:(NSInteger)from toItem:(NSInteger)toItem{

    if (toItem < 0 || toItem >= self.childViewControllers.count) return;
    
    // 0.移除旧控制器的view
    UIViewController *oldVc = self.childViewControllers[from];
    [oldVc.view removeFromSuperview];
    
    // 1.取出即将显示的控制器
    UIViewController *newVc = self.childViewControllers[toItem];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - 49;
    newVc.view.frame = CGRectMake(0, 0, width, height);
    
    // 2.添加新控制器的view到MainController上面
    [self.view addSubview:newVc.view];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
