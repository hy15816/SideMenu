//
//  TestCircleVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/12.
//  Copyright © 2015年 hyIm. All rights reserved.
//  拖动或点击改变进度

#import "TestCircleVC.h"
#import "CircleProgressView.h"

@interface TestCircleVC ()

@property (strong,nonatomic) CircleProgressView *circleProgressView;
@end

@implementation TestCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.circleProgressView = [[CircleProgressView alloc] initWithFrame:CGRectMake(50, 50, 200, 200) backColor:[UIColor groupTableViewBackgroundColor] progressColor:[UIColor greenColor] lineWidth:10.f];
    [self.view addSubview:self.circleProgressView];
    
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
