//
//  ScanVC.m
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/14.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//  自带扫描
/**
 *  1.导入<AVFoundation/AVFoundation.h>
 *  2.about scan
 *  3.创建
 *  4.start
 *  5.实现<AVCaptureMetadataOutputObjectsDelegate>
 *  6.设置扫描范围，AVCaptureMetadataOutput属性rectOfInterest
 */

#define ScanSquareWidth 220
#define ScanSquareY     120

#define kTAG_SHOW_WEBVIEW   15101601    //显示网页
#define kTAG_SHOW_TEXT      15101602    //显示文字

#import "ScanVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanResultVC.h"

@interface ScanVC ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    BOOL flashIsOn;     //灯光开关
    UIView *shadeView;  //遮罩
    
    int num;
    BOOL upOrDown;      //下降or上升
    NSTimer *timer;     //定时器
}

@property (strong, nonatomic) IBOutlet UIView *bottomView;

//========about scan========
@property (strong , nonatomic ) AVCaptureDevice *capDevice;                 //抽象的硬件设备。
@property (strong , nonatomic ) AVCaptureDeviceInput * capDvcInput;         //输入设备（可以是它的子类），它配置抽象硬件设备的ports。
@property (strong , nonatomic ) AVCaptureMetadataOutput * capMtdOutput;     //输出数据，管理着输出到一个movie或者图像。
@property (strong , nonatomic ) AVCaptureSession * capSession;              //input和output的桥梁。它协调着intput到output的数据传输。
@property (strong , nonatomic ) AVCaptureVideoPreviewLayer * capVdoPvLayer; //视频预览层
@property (strong , nonatomic ) UIImageView *lineImgv;

@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIButton *turnLight;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
- (IBAction)turnLightClick:(UIButton *)sender;
- (IBAction)leftButtonClick:(UIButton *)sender;
- (IBAction)tightButtonClick:(UIButton *)sender;

@end

@implementation ScanVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (shadeView) {
        [shadeView removeFromSuperview];
        [_capSession startRunning];
    }
    if (!_lineImgv) {
        [self addRunImage];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAVCap];
    self.bottomView.backgroundColor = kCOLORVALUE(0x000000, .2);
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    
    //add bg
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QR_saomiaoBG"]];
    bg.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    bg.alpha = 0.5;
    [self.view addSubview:bg];//200x188
    
}

/**
 *  背景图片
 */
-(void)addRunImage{
    _lineImgv = [[UIImageView alloc] initWithFrame:CGRectMake((kDEVICE_WIDTH- ScanSquareWidth+10)/2, ScanSquareY+20, ScanSquareWidth-10, 2)];
    _lineImgv.image = [UIImage imageNamed:@"line"];
    [self.view addSubview:_lineImgv];
    upOrDown =  NO;
    num = 0;
    [self imgvAnimation];
    //timer = [NSTimer scheduledTimerWithTimeInterval:.03f target:self selector:@selector(imgvAnimation) userInfo:nil repeats:YES];
    //[timer fire];
}

/**
 *  上下循环运动的图片
 */
-(void)imgvAnimation{
    
    //NSLog(@"NSTimer was running。。。");
    if (upOrDown == NO) {
        num ++;
        _lineImgv.frame = CGRectMake((kDEVICE_WIDTH- ScanSquareWidth+10)/2, ScanSquareY+20+2*num, ScanSquareWidth-10, 2);
        if (2*num == ScanSquareWidth-30) {
            upOrDown = YES;
        }
    }
    else {
        num --;
        _lineImgv.frame = CGRectMake((kDEVICE_WIDTH- ScanSquareWidth+10)/2, ScanSquareY+20+2*num, ScanSquareWidth-10, 2);
        if (num == 0) {
            upOrDown = NO;
        }
    }
    
    [self performSelector:@selector(imgvAnimation) withObject:nil afterDelay:.03f];
}

/**
 *  创建avCap
 */
-(void)createAVCap{
    //创建
    _capDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    _capDvcInput = [AVCaptureDeviceInput deviceInputWithDevice:self.capDevice error:&error];
    if (error) {
        NSLog(@"你手机不支持二维码扫描!");
        return;
    }
    _capMtdOutput = [[AVCaptureMetadataOutput alloc] init];
    [_capMtdOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置指定的扫描范围，中间一个220x220的区域
    [_capMtdOutput setRectOfInterest:CGRectMake (ScanSquareY/kDEVICE_HEIGHT,((kDEVICE_WIDTH - ScanSquareWidth )/2 )/ kDEVICE_WIDTH , ScanSquareWidth/kDEVICE_HEIGHT , ScanSquareWidth/kDEVICE_WIDTH )];//这个属性df-> CGRectMake(0, 0, 1, 1),比例关系，设置时注意，CGRectMake(y, x, h, w),因为是比例，所以 ? = 实际/DEVICE的高或宽
    
    _capSession = [[AVCaptureSession alloc] init];
    [_capSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_capSession canAddInput:self.capDvcInput]) {
        [_capSession addInput:self.capDvcInput];
    }
    if ([_capSession canAddOutput:self.capMtdOutput]) {
        [_capSession addOutput:self.capMtdOutput];
    }
    
    //条码类型
    _capMtdOutput.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ];
    
    //preview layer
    _capVdoPvLayer = [AVCaptureVideoPreviewLayer layerWithSession:_capSession];
    _capVdoPvLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _capVdoPvLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_capVdoPvLayer atIndex:0];
    
    //start
    [_capSession startRunning];
    
    //实现<AVCaptureMetadataOutputObjectsDelegate>
    //设置扫描范围
    [self addRunImage];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if (metadataObjects.count > 0) {
        //停止扫描
        [_capSession stopRunning];
        AVMetadataMachineReadableCodeObject *mmrcObj = [metadataObjects objectAtIndex:0];
        stringValue = mmrcObj.stringValue;
        
        [self addview:stringValue];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(imgvAnimation) object:nil];
//        [timer invalidate];
        NSLog(@"stringValue:%@",stringValue);
        
    }
    
}

//添加一个遮罩view，
-(void)addview:(NSString *)string{
    shadeView = [[UIView alloc] initWithFrame:self.view.frame];
    shadeView.backgroundColor = [UIColor grayColor];
    shadeView.alpha = .9;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, (kDEVICE_HEIGHT-20)/2, kDEVICE_WIDTH, 20)];
    l.text = @"正在处理...";
    [shadeView addSubview:l];
    [self.view addSubview:shadeView];
    NSLog(@"string:%@",string);
    if (string.length > 4) {
        if ([[string substringToIndex:4] isEqualToString:@"http"]) {
            [self showMessage:string tag:kTAG_SHOW_WEBVIEW];
            l.alpha =0;
        }

    }else{
        ScanResultVC *result = [kLeftStoryboard instantiateViewControllerWithIdentifier:@"ScanResultVCIDF"];
        result.showType = ShowTypeText;
        result.urlString = string;
        [self.navigationController pushViewController:result animated:YES];
        l.alpha =0;
    }
    
}

#pragma mark - UIAlertViewDelegate
-(void)showMessage:(NSString *)message tag:(NSInteger)tag{

    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"是否打开链接?" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    a.tag = tag;
    [a show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.message]];
        ScanResultVC *result = [kLeftStoryboard instantiateViewControllerWithIdentifier:@"ScanResultVCIDF"];
        result.showType = ShowTypeWebView;
        result.urlString = alertView.message;
        [self.navigationController pushViewController:result animated:YES];
    }else{
        [shadeView removeFromSuperview];
        [_capSession startRunning];
        [self imgvAnimation];
    }
}

#pragma mark - 灯光开关控制
- (IBAction)turnLightClick:(UIButton *)sender {
    if(flashIsOn == NO)
    {
        [sender setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
        [sender setTitle:@"关灯" forState:UIControlStateNormal];
        [self turnTorchOn:YES];
    }else{
        [sender setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
        [sender setTitle:@"开灯" forState:UIControlStateNormal];
        [self turnTorchOn:NO];

    }
    
    flashIsOn = !flashIsOn;
}

/**
 *  手动打开或关闭闪光灯
 *
 *  @param on YES是，NO否
 */
- (void)turnTorchOn:(BOOL)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash])
        {
            [device lockForConfiguration:nil];
            if (on)
            {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            }
            else
            {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

- (IBAction)leftButtonClick:(UIButton *)sender {
}

- (IBAction)tightButtonClick:(UIButton *)sender {
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


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_lineImgv removeFromSuperview];
    _lineImgv = nil;
    [_capSession stopRunning];
//    [timer invalidate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(imgvAnimation) object:nil];

}
@end
