//
//  FirstVC.m
//  hiu
//
//  Created by AEF-RD-1 on 15/10/8.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight   self.navigationController.navigationBar.frame.size.height

#import "FirstVC.h"
#import "UIScrollView+touches.h"
#import "PopView.h"
#import "MusicListCell.h"
#import "MusicRecord.h"
#import "GuideView.h"
#import "TestCellTableVC.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

#define bCarLoginURL @"http://112.74.128.144:8189/AnerfaBackstage/login/login.do"//登陆

@interface FirstVC ()<UITableViewDataSource,UITableViewDelegate,PopViewDelegate>

@property (assign) BOOL isShowView;
@property (strong,nonatomic) UIView *shadowView;
@property (strong,nonatomic) PopView *rightView;
@property (strong,nonatomic) UISegmentedControl *segmentControl;
@property (strong,nonatomic) UITableView *tableViewf;

@property (strong,nonatomic) NSMutableArray *nameArray;
@property (strong,nonatomic) NSMutableArray *imgArray;

@property (strong,nonatomic) NSMutableArray *musicRecordArray;

@end

@implementation FirstVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addGudieView];
    //});
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isShowView = NO;
    
    self.view.backgroundColor = [UIColor grayColor];
    
    //右上角item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightsBtnClick:)];
    
    //[self checkMyversion];
    [self initSubViews];
    /*
    NSDictionary *d = @{@"key":@"18565667965",@"password":@"3333"};
    [GlobalTool getJSONWithUrl:bCarLoginURL parameters:d success:^(id accept){
        NSLog(@"accept:%@",accept);
    } fail:^(NSError *error){}];
    */
    
    [self deviceIPAdress];
    [self getIpAddresses];
}

#pragma mark - 添加显示引导页面
-(void)addGudieView{
    
    if (![kUSERDFS valueForKey:kFirstLaunch]) {
        GuideView *gview = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kDEVICE_WIDTH, kDEVICE_HEIGHT)];
        NSMutableArray *images  = [[NSMutableArray alloc] initWithObjects:@"image_leftImg",@"image_leftImg",@"image_leftImg", nil];
        [gview setImages:images];
        UIWindow *win = [UIApplication sharedApplication].keyWindow ;
        [win addSubview:gview];
        [kUSERDFS setValue:@"1" forKey:kFirstLaunch];
        
    }
}
/**
 *  获取设备网络ip地址,需引入<ifaddrs.h>,<arpa/inet.h>
 *
 *  @return string ip地址
 */
- (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);  
    
    NSLog(@"手机的IP是：%@", address);
    return address;  
}


/**
 *  遍历所有ipv4网卡，查询网卡名称是否包含“bridge”即可判断当前热点是否启动。,。
 *  lo0:        本地ip(127.0.0.1)
 *  en0:        局域网/广域网ip(192.168.1.10)
 *  pdp_ip0:    WWAN地址，即3G ip(10.225.52.253)
 *  bridge0:    桥接、热点ip(172.20.10.1)
 */

// Get All ipv4 interface
- (void)getIpAddresses {
    //NSMutableDictionary* addresses = [[NSMutableDictionary alloc] init];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    @try {
        // retrieve the current interfaces - returns 0 on success
        NSInteger success = getifaddrs(&interfaces);
        //NSLog(@"%@, success=%d", NSStringFromSelector(_cmd), success);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Get NSString from C String
                    NSString* ifaName = [NSString stringWithUTF8String:temp_addr->ifa_name];
                    NSString* address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                    NSString* mask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_netmask)->sin_addr)];
                    NSString* gateway = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_dstaddr)->sin_addr)];
                    
                    /*
                    AXNetAddress* netAddress = [[AXNetAddress alloc] init];
                    netAddress.name = ifaName;
                    netAddress.address = address;
                    netAddress.netmask = mask;
                    netAddress.gateway = gateway;
                    NSLog(@"netAddress=%@", netAddress);
                    addresses[ifaName] = netAddress;
                     */
                    NSLog(@" ifaName---%@, address---%@, mask---%@, gateway---%@ \n",ifaName,address,mask,gateway);
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"aaaaaaaaaaaaaaaa Exception: %@", exception);
    }
    @finally {
        // Free memory
        freeifaddrs(interfaces);
    }
    //return addresses;
}


//初始化控件
-(void)initSubViews{
    
    //segment
    _segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"新闻",@"音乐", nil]];
    _segmentControl.frame = CGRectMake((self.view.frame.size.width - self.view.frame.size.width/4.f)/2, 12, self.view.frame.size.width/4.f, 20);
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self action:@selector(segmentSelectindex:) forControlEvents:UIControlEventValueChanged];
    //2种添加方式
    self.navigationItem.titleView = _segmentControl;
    //[self.navigationController.navigationBar addSubview: tv];
    
    _nameArray = [[NSMutableArray alloc] initWithObjects:@"11111",@"22222",@"55555",@"66666",@"88888",@"99999",@"00000",@"33333",@"qqqqq",@"hhhhh", nil];
    _imgArray = [[NSMutableArray alloc] initWithObjects:@"yi",@"er",@"wu",@"liu",@"ba",@"jiu",@"ling",@"san",@"qq", nil];
    
    _musicRecordArray = [[NSMutableArray alloc] init];
    for (int i=0; i<5; i++) {
        MusicRecord *music = [[MusicRecord alloc] init];
        music.songerIcon = [NSString stringWithFormat:@"ooopic_1%d",i+1];
        if (i%2==1) {
            music.songerIcon = @"";
        }
        music.songerName = [NSString stringWithFormat:@"name%d",i];
        music.musicName = [NSString stringWithFormat:@"music%d这是歌名这是歌名这是歌名这是歌名这是歌名这是歌名这是歌名",i];
        if (i==4) {
            music.musicName = [NSString stringWithFormat:@"music%d这是歌名这是",i];

        }
        [_musicRecordArray addObject:music];
    }
    
    //tableView
    _tableViewf = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableViewf.delegate = self;
    _tableViewf.dataSource = self;
    _tableViewf.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableViewf];
    
    // _shadowView && _rightView
    CGRect rect = [[UIScreen mainScreen] bounds];
    _shadowView = [[UIView alloc] initWithFrame:rect];
    _shadowView.backgroundColor = [UIColor whiteColor];
    _shadowView.alpha = 0;
    UIWindow *win = [UIApplication sharedApplication].keyWindow ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(tapShadowView:)];
    [_shadowView addGestureRecognizer:tap];
    [win addSubview:_shadowView];
    
    _rightView = [[PopView alloc] initWithViewItems:[NSArray arrayWithObjects:@"click1",@"click2",@"click3",@"click4", nil] frame:CGRectMake(self.view.frame.size.width-150, kNavBarHeight+kStatusBarHeight+5, 145, 175)];
    _rightView.alpha = 0;
    _rightView.delegate = self;
    _rightView.layer.cornerRadius = 5;
    _rightView.layer.borderWidth = .5;
    _rightView.layer.borderColor = [UIColor blackColor].CGColor;
    [win addSubview:_rightView];
    
}

#pragma mark - PopViewDelegate
-(void)popViewItemClick:(UIButton *)btn{
    
    NSLog(@"btn.tag %lu",btn.tag);
    [self dismissRightView];
    
    if (btn.tag == 3) {
        TestCellTableVC *test = [kMainStoryboard instantiateViewControllerWithIdentifier:@"TestCellTableVCIDF"];
        [self.navigationController pushViewController:test animated:YES];
    }else{
        UIViewController *ctrol = [[UIViewController alloc] init];
        ctrol.title = btn.titleLabel.text;
        ctrol.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:ctrol animated:YES];
    }
    
    
}

#pragma mark - tap
-(void)tapShadowView:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self dismissRightView];
    }
}

#pragma mark - UISegmentedControl
-(void)segmentSelectindex:(UISegmentedControl *)segment{
    
    NSInteger index = segment.selectedSegmentIndex;
    if (index == 0) {
//        NSLog(@"0");
    }
    
    if (index == 1) {
//        NSLog(@"1");//获取数据
        
    }
    [_tableViewf reloadData];
    
}

#pragma mark - UINavigationItem
-(void)rightsBtnClick:(UIBarButtonItem *)item{
    //
    _isShowView = !_isShowView;
    [UIView animateWithDuration:.25 animations:^{
        if (_isShowView) {//显示弹窗
            _rightView.alpha = 1;
            _shadowView .alpha = .1;
        }
        
    }];
    
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_segmentControl.selectedSegmentIndex == 1) {
        return _musicRecordArray.count;
        
    }
    return MIN(_nameArray.count, _imgArray.count);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (_segmentControl.selectedSegmentIndex == 0) {
        
        cell.textLabel.text = _nameArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
        return cell;
    }
    
    MusicListCell *musicCell = [MusicListCell cellWithTableView:tableView];
    musicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    musicCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (_segmentControl.selectedSegmentIndex == 1) {
        
        MusicRecord *record = _musicRecordArray[indexPath.row];
        [musicCell.songerIcon setImage:[UIImage imageNamed:record.songerIcon.length>0?record.songerIcon:@"loadingIcon"] forState:UIControlStateNormal];
        musicCell.songerAndMusic.text = [NSString stringWithFormat:@"%@ - %@",record.songerName,record.musicName];
        return musicCell;
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *ctrol = [[UIViewController alloc] init];
    ctrol.view.backgroundColor = [UIColor yellowColor];
    [self.navigationController pushViewController:ctrol animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self dismissRightView];
}
-  (void)checkMyversion{
    
    //获取本地版本
    NSString  *localVersionString =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    localVersionString = [localVersionString stringByReplacingOccurrencesOfString:@"." withString:@""];
    int localVersion = [localVersionString intValue];
    NSLog(@"localVersion:%d",localVersion);
    [GlobalTool postJSONWithUrl:@"http://112.74.128.144:8189/AnerfaBackstage/versionCode/findVersionCode.do" parameters:@{@"":@""} success:^(NSArray *acceptData){
        NSLog(@"acceptData:%@",acceptData);
        NSString *serviceVersionString = [[acceptData objectAtIndex:0] objectForKey:@"iphoneDownloadurl"];
        serviceVersionString = [serviceVersionString stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        if (localVersion == [serviceVersionString intValue]) {
            //
            NSLog(@"已经是最新版本");
            //[AlertView showMessage:@"已经是最新版本" time:1.];
        }
        if (localVersion < [serviceVersionString intValue]) {
            //
            NSLog(@"提示更新");
        }
    } fail:^(NSError *error){
        
    }];
    
}

//
//收回弹窗
- (void)dismissRightView{
    //若是_rightView在弹出状态，则收回
    if (_isShowView) {
        _isShowView = NO;
        [UIView animateWithDuration:.25 animations:^{
            _rightView.alpha = 0;
            _shadowView.alpha = 0;
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
