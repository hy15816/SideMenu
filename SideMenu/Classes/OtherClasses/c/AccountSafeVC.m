//
//  AccountSafeVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/13.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "AccountSafeVC.h"

@interface AccountSafeVC ()
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;
- (IBAction)aTapsFromImageView:(UITapGestureRecognizer *)sender;

@end

@implementation AccountSafeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)aTapsFromImageView:(UITapGestureRecognizer *)sender {
    NSLog(@"aTapsFromImageView");
}
@end
