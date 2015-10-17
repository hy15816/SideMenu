//
//  LeftMenuViewController.m
//  hiu
//
//  Created by AEF-RD-1 on 15/10/7.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//


#define cellHeight  54      //cell行高

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"to first vc",@"二维码",@"Calendar",@"设置", nil];
    _imageArray = [[NSMutableArray alloc] initWithObjects:@"IconHome",@"IconProfile",@"IconCalendar",@"IconSettings", nil];
    
    //图片
    UIButton *userIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [userIcon setFrame:CGRectMake(10, 60, 50, 50)];
    userIcon.layer.cornerRadius = 25;
    userIcon.tag = kTAG_USER_ICON;
    [userIcon addTarget:self action:@selector(userIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userIcon setImage:[UIImage imageNamed:@"userIcon"] forState:UIControlStateNormal];
    [self.view addSubview:userIcon];
    
    
    //名字
    UIButton *userName = [UIButton buttonWithType:UIButtonTypeCustom];
    [userName setFrame:CGRectMake(70, 60, self.view.frame.size.width-70, 25)];
    userName.titleLabel.textAlignment = NSTextAlignmentLeft;//这里只是button中的标签对齐方式，但标签本身并没有改变位置，
    userName.backgroundColor = [UIColor clearColor];
    [userName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userName setTitle:@"user name" forState:UIControlStateNormal];
    userName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //使button内容对齐设置为左对齐，在使用titleEdgeInsets使文字距离左边10px
    userName.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    userName.tag = kTAG_USER_NAME;
    [userName addTarget:self action:@selector(userIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userName];
    
    //签名
    UIButton *userSign = [UIButton buttonWithType:UIButtonTypeCustom];
    [userSign setFrame:CGRectMake(0, 120, self.view.frame.size.width, 20)];
    userSign.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [userSign setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [userSign setTitle:@"user sign" forState:UIControlStateNormal];
    userSign.tag = kTAG_USER_SIGN;
//    userSign.titleLabel.textAlignment = NSTextAlignmentLeft;
    userSign.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  //使button内容对齐设置为左对齐，在使用titleEdgeInsets使文字距离左边10px
    userSign.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [userSign addTarget:self action:@selector(userIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userSign];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - cellHeight * 5) / 2.0f, self.view.frame.size.width, cellHeight * 5) style:UITableViewStylePlain];
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
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
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
    return cellHeight;
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
