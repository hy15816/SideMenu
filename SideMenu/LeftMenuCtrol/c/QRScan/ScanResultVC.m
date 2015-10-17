//
//  ScanResultVC.m
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/15.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//  显示扫描的结果

#import "ScanResultVC.h"

@interface ScanResultVC ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *resultWebView;
@property (strong, nonatomic) IBOutlet UITextView *resultTextView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backFirstCtrol;
- (IBAction)backFirstCtrolClick:(UIBarButtonItem *)sender;

@end

@implementation ScanResultVC
@synthesize showType,urlString;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.backFirstCtrol.enabled = NO;
    // Do any additional setup after loading the view.
    
    if (showType == ShowTypeText) {
        self.resultWebView.hidden = YES;
        self.resultTextView.text = urlString;
    }else{
        self.resultTextView.hidden = YES;
        if (urlString.length) {
            //打开
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
            [self.resultWebView loadRequest:request];
            self.resultWebView.delegate =self;
        }
    }
    
    //self.resultTextView.hidden = YES;
    //self.resultWebView.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //父类方法，
    [self showProViewSec:ShowProgressTypeOther];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    //NSLog(@" 载入。。。。");
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone  ];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //NSLog(@"加载结束");
    [SVProgressHUD dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"发生错误"];
    //NSLog(@"发生错误Error：%@",error);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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

- (IBAction)backFirstCtrolClick:(UIBarButtonItem *)sender {
//    NSLog(@"- childViewControllers.count %lu",(unsigned long)self.navigationController.childViewControllers.count);
//    NSArray *ctrols = self.navigationController.childViewControllers;
//    NSLog(@"ctrols:%@",ctrols);
////    [self.navigationController popToViewController:[ctrols objectAtIndex:0] animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}
@end
