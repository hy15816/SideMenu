//
//  LeftMenuViewController.m
//  hiu
//
//  Created by AEF-RD-1 on 15/10/7.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//


#define kLeftTableCellHeight    44                  //cell行高
#define kLeftTableViewWidth self.view.frame.size.width *.75f    //tableview的宽
#define kUserSignBtnHight      20.f     //签名Btn的高
#define kMarginTops             5.f     //控件垂直间距

#import "LeftMenuViewController.h"
#import "RootViewController.h"
#import "UIViewController+sideMenu.h"
#import "HYNavVC.h"
#import "RESideMenu.h"

@interface LeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation LeftMenuViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //接收跳转页面通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myIconDidChanged) name:kMyIconDidChanged object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"Dynamic",@"二维码",@"Calendar",@"设置",@"进度条",@"多选照片",@"测试定位", nil];
    _imageArray = [[NSMutableArray alloc] initWithObjects:@"IconHome",@"IconProfile",@"IconCalendar",@"IconSettings",@"IconSettings",@"IconSettings",@"IconSettings", nil];
    
    //图片
    UIButton *userIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [userIcon setFrame:CGRectMake(10, 50, 50, 50)];
    userIcon.layer.cornerRadius = 25;
    userIcon.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    userIcon.layer.borderWidth = .5f;
    userIcon.layer.masksToBounds = YES;
    userIcon.tag = kTAG_USER_ICON;
    [userIcon addTarget:self action:@selector(userIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userIcon setImage:[GlobalTool getMyIcon] forState:UIControlStateNormal];
    [self.view addSubview:userIcon];
    
    CGFloat userX = userIcon.frame.origin.x;
    CGFloat userY = userIcon.frame.origin.y;
    CGFloat userW = userIcon.frame.size.width;
    CGFloat userH = userIcon.frame.size.height;
    
    //名字
    UIButton *userName = [UIButton buttonWithType:UIButtonTypeCustom];
    [userName setFrame:CGRectMake(userX + userW + kMarginTops, userH, kLeftTableViewWidth-70, 25)];
    userName.titleLabel.textAlignment = NSTextAlignmentLeft;//这里只是button中的标签对齐方式，但标签本身并没有改变位置，
    userName.backgroundColor = [UIColor clearColor];
    userName.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [userName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    userName.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;//结尾用...表示
    [userName setTitle:@"显示昵称，秋天的凉,绕指丶漠铭的殇" forState:UIControlStateNormal];
    userName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //使button内容对齐设置为左对齐，在使用titleEdgeInsets使文字距离左边10px
    userName.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    userName.tag = kTAG_USER_NAME;
    [userName addTarget:self action:@selector(userIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userName];
    
    UIButton *userLever = [UIButton buttonWithType:UIButtonTypeCustom];
    [userLever setTitle:@"☀️☀️✨✨" forState:UIControlStateNormal];
    userLever.backgroundColor = [UIColor clearColor];
    userLever.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    userLever.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    userLever.frame = CGRectMake(userX+ userW + kMarginTops, userY+userH - 25, kLeftTableViewWidth-70, 15);
    [self.view addSubview:userLever];
    
    //签名
    UIButton *userSign = [UIButton buttonWithType:UIButtonTypeCustom];
    [userSign setFrame:CGRectMake(0, userY+ userH +kMarginTops , kLeftTableViewWidth, kUserSignBtnHight)];
    userSign.backgroundColor = [UIColor clearColor];
    [userSign setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    [userSign setTitle:@"这里是签名，你的签名，测试文字，测试文字，测试文字" forState:UIControlStateNormal];
    userSign.tag = kTAG_USER_SIGN;
    userSign.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    userSign.titleLabel.font = [UIFont systemFontOfSize:14];
    //    userSign.titleLabel.textAlignment = NSTextAlignmentLeft;
    userSign.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //使button内容对齐设置为左对齐，在使用titleEdgeInsets使文字距离左边10px
    userSign.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);//左边缩进10
    [userSign addTarget:self action:@selector(userIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userSign];

    //table view
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, userY+ userH + kMarginTops*2 + kUserSignBtnHight , kLeftTableViewWidth, kLeftTableCellHeight * _titleArray.count) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
}

/**
 *  头像已经改变
 */
- (void)myIconDidChanged{
    
    UIButton *b = [self.view viewWithTag:kTAG_USER_ICON];
    [b setImage:[GlobalTool getMyIcon] forState:UIControlStateNormal];
}

#pragma mark
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLeftTableCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self setContentVCAndPushIndex:indexPath.row+1];
}

-(void)userIconBtnClick:(UIButton *)button{
    NSInteger index = 0;
    if (button.tag == kTAG_USER_ICON) {
        index = kTAG_USER_ICON;
    }
    
    if (button.tag == kTAG_USER_NAME) {
        index = kTAG_USER_NAME;
    }
    
    if (button.tag == kTAG_USER_SIGN) {
        index = kTAG_USER_SIGN;
    }
    [self setContentVCAndPushIndex:index];
}

-(void)setContentVCAndPushIndex:(NSInteger)index{
    RootViewController *rootvc = [[RootViewController alloc] init];
    //HYNavVC *controller = [[HYNavVC alloc] initWithRootViewController:rootvc];
    rootvc.isPushIndex = index;
    rootvc.isShowSecondVC = YES;
    [self.sideMenuViewController setContentViewController:rootvc animated:YES];
    [self.sideMenuViewController hideMenuViewController];
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
