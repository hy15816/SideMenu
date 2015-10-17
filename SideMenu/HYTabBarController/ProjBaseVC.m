//
//  ProjBaseVC.m
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/23.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//  一级界面基础ctro

#import "ProjBaseVC.h"
#import "UIViewController+sideMenu.h"

@interface ProjBaseVC ()

@end

@implementation ProjBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //左上角item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconProfile"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick:)];
    
    //子ctorl的backItem
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}
- (void)leftBtnClick:(UINavigationItem *)item{
    //隐藏barItem
    //NSLog(@"hidden");
    //self.navigationItem.leftBarButtonItem.enabled = NO;
    [self performSelector:@selector(presentLeftMenuViewController:) withObject:nil afterDelay:0];
}
-(void)abc{
    
    
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
