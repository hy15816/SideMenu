//
//  ProjBaseSecVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/13.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//  二级界面基础ctro

#import "ProjBaseSecVC.h"

@interface ProjBaseSecVC ()
{
    NSTimer *pTimer;
}
@end

@implementation ProjBaseSecVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加一个进度条
    proViewSec  =[[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    proViewSec.progress = 0.0f;
    proViewSec.alpha = 0.f;
    proViewSec.backgroundColor = [UIColor clearColor];
    proViewSec.tintColor = [UIColor greenColor];       //已完成进度颜色
    proViewSec.trackTintColor = [UIColor clearColor];  //底色
    proViewSec.window.windowLevel = 1000;           //设置view的显示级别，
    [self.view addSubview:proViewSec];
    
    //子ctorl的backItem
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)showProViewSec:(ShowProgressType)type{
    
    if (type == ShowProgressTypeOther) {
        proViewSec.frame = CGRectMake(0, 64, self.view.frame.size.width, 1);
    }
    proViewSec.alpha = 1.f;
    
    //NSLog(@"ProjBaseSecVC.progress.value - %f",proValue);
    [proViewSec setProgress:.75f animated:YES];
    //@synchronized(self){
        //pTimer =  [NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(changeProValueSec) userInfo:nil repeats:YES];
    //}
}

-(void)changeProValueSec:(CGFloat)proValue{
    
    [proViewSec setProgress:proValue animated:YES];
    //proValue+=.0005f;
    if (proValue>=1) {
        NSLog(@"ProjBaseSecVC.progress.value - %f",proValue);
        [UIView animateWithDuration:.5 animations:^{
            proViewSec.alpha = 0;
        }];
    }
    
    
    
    
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
