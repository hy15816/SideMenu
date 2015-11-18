//
//  ShowBigViewController.m
//  testKeywordDemo
//
//  Created by mei on 14-8-18.
//  Copyright (c) 2014年 Bluewave. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "ShowBigViewController.h"
#define IOS7LATER  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
@interface ShowBigViewController ()
{
    int currentIndex;
}
@end

@implementation ShowBigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏的rightButton
 
    rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame=CGRectMake(0, 0, 22, 22);
    [rightbtn setImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(OK:)forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    [self layOut];
    
}

-(void)layOut{
    
    self.view.backgroundColor = [UIColor blackColor];
    //arrayOK里存放选中的图片
    
    _scrollerview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-114, self.view.frame.size.width, 50)];
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    bottomView.alpha = .9;
    
    _btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnOK.frame = CGRectMake(bottomView.frame.size.width - 70,  (bottomView.frame.size.height-32)/2, 61, 32);
    //显示选中的图片的大图
    _scrollerview.backgroundColor = [UIColor whiteColor];
    _scrollerview.delegate = self;
    _scrollerview.pagingEnabled = YES;
    NSLog(@"self.arrayOK.count is %lu",(unsigned long)self.arrayOK.count);
 
    for (int i=0; i<[self.arrayOK count]; i++) {
       ALAsset *asset=self.arrayOK[i];
        
        UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollerview.frame.size.width, 0, _scrollerview.frame.size.width, _scrollerview.frame.size.height)];
                   imgview.contentMode=UIViewContentModeScaleAspectFill;
                    imgview.clipsToBounds=YES;
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imgview setImage:tempImg];
        [_scrollerview addSubview:imgview];
    }
    
    _scrollerview.contentSize = CGSizeMake((self.arrayOK.count) * (self.view.frame.size.width),0);
    [self.view addSubview:_scrollerview];
    
    //点击按钮，回到主发布页面
    [_btnOK setBackgroundImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
    [_btnOK setTitle:[NSString stringWithFormat:@"完成(%lu)",(unsigned long)self.arrayOK.count] forState:UIControlStateNormal];
    _btnOK .titleLabel.font = [UIFont systemFontOfSize:10];
    [_btnOK addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    [bottomView addSubview:_btnOK];
    
    
}
-(void)complete:(UIButton *)sender{
    NSLog(@"完成了,跳到主发布页面");
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void)OK:(UIButton *)sender{
    
    [rightbtn setImage:[UIImage imageNamed:@"No.png"] forState:UIControlStateNormal];
    NSLog(@"点击了按钮，就取消选中这个图片");
    
}

#pragma  mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //设定y为0
    _scrollerview.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    //滚动图片，改变小点的显示位置
    int index = fabs(_scrollerview.contentOffset.x) / _scrollerview.frame.size.width;
    NSLog(@"index:%d",index);
    if (currentIndex != index) {
        currentIndex = index;
        [rightbtn setImage:[UIImage imageNamed:@"Ok.png"] forState:UIControlStateNormal];
    }
    
}


-(void)dismiss{

    [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
