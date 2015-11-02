//
//  SecondVC.m
//  hiu
//
//  Created by AEF-RD-1 on 15/10/8.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "SecondVC.h"
#import "SegmentView.h"

@interface SecondVC ()<SegmentViewDelegate>

@property (strong,nonatomic) SegmentView *segmentView;

@end

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"2";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(50, 150, 50, 30) delegate:self items:[NSArray arrayWithObjects:@"摇一摇开闸",@"自动开闸", nil] font:[UIFont systemFontOfSize:18]];
    //self.segmentView.moveViewColor = [UIColor redColor];
    [self.view addSubview:self.segmentView];
    
}


- (void)segmentView:(SegmentView *)segmentView didSelectIndex:(NSInteger)index{
    NSLog(@"index:%ld",(long)index);
    
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
