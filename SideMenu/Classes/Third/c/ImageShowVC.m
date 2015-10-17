//
//  ImageShowVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/13.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "ImageShowVC.h"

@interface ImageShowVC ()

@end

@implementation ImageShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //父类方法，
    [self showProViewSec:ShowProgressTypeDefault];
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
