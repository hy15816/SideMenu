//
//  QRCodeVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/16.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//  生成二维码

#import "QRCodeVC.h"
#import "QRCodeView.h"

@interface QRCodeVC ()
@property (strong, nonatomic) IBOutlet UIImageView *qrImage;
@property (strong, nonatomic) IBOutlet UIImageView *smallIcon;
- (IBAction)createMyQRCode:(UIBarButtonItem *)sender;

@end

@implementation QRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createMyQRCodeWithString:@"http://www.cnblogs.com/hyim"];
    //添加阴影
    self.qrImage.layer.shadowOffset = CGSizeMake(0, 2);
    self.qrImage.layer.shadowRadius = 2;
    self.qrImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.qrImage.layer.shadowOpacity = 0.5;
    
    self.smallIcon.image = [UIImage imageNamed:@"ooopic_icon_35"];
    
}

- (void)createMyQRCodeWithString:(NSString *)str {
    
//    UIImage *qrImage = [[QRCodeView alloc] createQRImageWithStr:str height:(self.view.frame.size.width - 50)/2.f];
    UIImage *qrImage = [[QRCodeView alloc] createQRImageWithStr:str height:(self.view.frame.size.width - 50)/2.f withRed:60.f andGreen:74.f andBlue:89.f];////二维码图片将要显示的颜色
    self.qrImage.image = qrImage;
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
#define kGetDocCodeURL @"http://112.74.128.144:8189/AnerfaBackstage/devolutionLicense/devolutionCodeObtain.do"
- (IBAction)createMyQRCode:(UIBarButtonItem *)sender {
    [SVProgressHUD showWithStatus:@"正在生成"];
    NSDictionary *parmeter = @{@"user_name":@"18565667965",@"documentCode":@"71bc5f89bb3051853f7acb92c0d16408"};
    [GlobalTool postJSONWithUrl:kGetDocCodeURL parameters:parmeter success:^(NSDictionary *accept){
        NSLog(@"accept:%@",accept);
        
        if ([[accept objectForKey:@"code"] isEqualToString:@"45000"]) {
            //获取授权码成功，可以生成二维码
            //生成二维码需要的数据
            //1、授权码
            NSString *devolutionCode = [accept objectForKey:@"devolutionCode"];
            //2、当前用户名
            NSString *currentUserName = @"18565667965";
            //3、车牌号
            NSString *carNumber = @"粤SYE556";
            
            //NSDictionary *d = @{@"u":currentUserName,@"devo":devolutionCode,@"car":carNumber};
            //NSData *data = [self dataFromDict:d];
            //NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            //NSString *string =[NSString stringWithFormat:@"{\"u\":\"%@\",\"devo\":\"%@\",\"car\":\"%@\"}",currentUserName,devolutionCode,carNumber]; //@"{\"u\":\"18565667965\",\"devo\":\"\"}";//[NSString stringWithFormat:@"u=%@&devo=%@&car=%@",currentUserName,devolutionCode,carNumber];
            NSString *string2 = [self dictStringFromkeys:[NSMutableArray arrayWithObjects:@"user",@"devo",@"car", nil] values:[NSMutableArray arrayWithObjects:currentUserName,devolutionCode,carNumber, nil]];
            //NSLog(@"string:%@",string);
            NSLog(@"string2:%@",string2);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createMyQRCodeWithString:string2];
                [SVProgressHUD dismiss];
            });
            
            
        }else{
            //
            NSLog(@"请重新登录！！！");
        }
    } fail:^(NSError *err){
        
    }];
    
}


/**
 *  根据key 和value 生成字典字符串，
 *
 *  @param keys   key array
 *  @param values value array
 *
 *  @return dict string ep:{"user":"username","pwd":"123456"}
 */
-(NSString *)dictStringFromkeys:(NSMutableArray *)keys values:(NSMutableArray *)values{
    
    NSString *string = [[NSString alloc] init];
    if (keys.count != values.count) {
        return @"";
    }
    for (int i=0; i<keys.count; i++) {
        NSString *str = [NSString stringWithFormat:@"\"%@\":\"%@\",",keys[i],values[i]];
        if (i == keys.count-1) {
            str = [NSString stringWithFormat:@"\"%@\":\"%@\"",keys[i],values[i]];
        }
        string = [NSString stringWithFormat:@"%@%@",string,str];
    }
    
    return [NSString stringWithFormat:@"{%@}",string];
}


@end
