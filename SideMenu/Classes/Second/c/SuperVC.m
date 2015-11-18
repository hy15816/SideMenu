//
//  SuperVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "SuperVC.h"

@interface SuperVC ()

@end

@implementation SuperVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    keyboardHelper = [[UIKeyboardHelper alloc] initWithKeyboardDelegate:self];
    [keyboardHelper addToolBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



/// 添加单击手势 用于取消键盘
- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViews)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapViews
{
    [self.view endEditing:YES];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    keyboardHelper = nil;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    //[self addTapGestureRecognizer];
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
