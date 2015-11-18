//
//  SecondVC.m
//  hiu
//
//  Created by AEF-RD-1 on 15/10/8.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "SecondVC.h"
#import "SegmentView.h"
#import "AlertView.h"
#import "TestKeyboardVC.h"

@interface SecondVC ()<SegmentViewDelegate,AlertViewDelegate>
{
    AlertView *updateAlert;
}
@property (strong,nonatomic) SegmentView *segmentView;

@end

@implementation SecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.开闸新增车牌：末尾是汉字的车牌的处理，如：粤S12345警，粤Z65B2港
    //2.修改推送方式：别名推送设置，并与服务器测试成功
    
    // Do any additional setup after loading the view.
    self.title = @"2";
    self.view.backgroundColor = [UIColor whiteColor];
    //NSLog(@"time1");
    //右上角item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goto"] style:UIBarButtonItemStylePlain target:self action:@selector(secondRightsBtnClick:)];
    
    self.segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(50, 150, 50, 30) delegate:self items:[NSArray arrayWithObjects:@"1234",@"5678", nil] font:[UIFont systemFontOfSize:14]];
    //self.segmentView.moveViewColor = [UIColor redColor];
    [self.view addSubview:self.segmentView];
    //NSLog(@"time2");
    /*
    updateAlert = [[AlertView alloc] initPopViewWithBackImage:[UIImage imageNamed:@"popView"] delegate:self Title:@"版本更新" Message:@"message" Buttons:@[@"马上更新",@"下次"]];
    [updateAlert initLeftButtonBackImage:@[@"but0",@"but0_d"]];
    [updateAlert initRightButtonBackImage:@[@"but2",@"but2_d"]];
     */
    //NSLog(@"time3");
    //粤Z65B2港:00005725
     NSData *data = [self byte:@"粤Z65B2港" carNumId:@"00005725"];//K123456:00005701
    NSLog(@"data:%@",data);
}

- (void)segmentView:(SegmentView *)segmentView didSelectIndex:(NSInteger)index{
    NSLog(@"index:%ld",(long)index);
    if (index) {
        [updateAlert showPopView];
    }
    
}

- (void)alertView:(AlertView *)alertView selectButtonAtIndex:(NSInteger)selectIndex {
    
    NSLog(@"i:%ld",(long)selectIndex);
    
}

- (void)secondRightsBtnClick:(UIBarButtonItem *)item{
    
    TestKeyboardVC *test = [kMainStoryboard instantiateViewControllerWithIdentifier:@"TestKeyboardVCIDF"];
    [self.navigationController pushViewController:test animated:YES];
    
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


-(NSData *)byte:(NSString *)carNum carNumId:(NSString *)numId{
    //
    //NSLog(@"carNum:%@---carNumId:%@",carNum,numId);
    
    NSMutableArray *allArray = [[NSMutableArray alloc]init];
    NSMutableArray *carArray = [[NSMutableArray alloc]init];
    
    [allArray addObject:@"128"];
    [allArray addObject:@"14"];
    NSString *lastStr = [[NSString alloc] init];
    for (int i =0; i<carNum.length; i++) {
        NSString *str =[carNum substringWithRange:NSMakeRange(i, 1)];
        //判断是否汉字，汉字特殊处理 如：粤S12345警，粤Z65B2港，等车牌
        if ([self isHanzi:[str characterAtIndex:0]] && i == carNum.length-1) {//是汉字 && 车牌最后一个字
            //
            lastStr = str;
            break;
        }
        [carArray addObject:str];
        
    }
    
    //NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shengfen" ofType:@"plist"];
    //NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *str1 = @"20";//[dic objectForKey:carArray[0]];//车牌首字，
    //arr[0] = str1;
    [allArray addObject:str1];//前3位(包括了车牌的前1位) 128 14 20
    
    // 小写转大写
    for ( int i=1; i<carArray.count; i++) {
        Byte by[1];
        unichar cc = [carArray[i] characterAtIndex:0];
        by[0] = cc;
        NSString *str =[NSString stringWithFormat:@"%d",by[0]];
        if (str.intValue >=97) {
            NSString *str2 =carArray[i];
            carArray[i] = str2.uppercaseString;
        }
    }
    
    //除去第一位后的所有车牌（最后没有汉字）
    for (int i = 1; i<carArray.count; i++) {
        Byte by[1];
        unichar cc = [carArray[i] characterAtIndex:0];
        by[0] = cc;
        NSString *str =[NSString stringWithFormat:@"%d",by[0]];
        [allArray addObject:str];
    }
    
    if (lastStr.length) {//第二种情况，最后一字是汉字，
        for (int i = 1; i<carArray.count; i++) {
            Byte by[1];
            unichar cc = [carArray[i] characterAtIndex:0];
            by[0] = cc;
            NSString *str =[NSString stringWithFormat:@"%d",by[0]];
            [allArray addObject:str];
        }
        //加上最后一个汉字，先转成代号，
        [allArray addObject:@"30"];
    }
    
    
    //NSMutableArray *array = [[NSMutableArray alloc]init];
    //车牌ID 6位
    NSString *phone1;
    if (numId.length <12) {
        NSString *string = @"";
        for (int i=0; i<12-numId.length; i++) {
            string  = [NSString stringWithFormat:@"%@%@",string,@"0"];
        }
        phone1 =[NSString stringWithFormat:@"%@%@",string,numId];
    }else{
        phone1 = [numId substringWithRange:NSMakeRange(numId.length - 12, 12)];
    }
    
    //
    for (int i =0; i<6; i++) {
        NSString *str = [phone1 substringWithRange:NSMakeRange(i*2, 2)];
        //        [array addObject:str];
        NSString *str1 = [NSString stringWithFormat:@"%lu",strtoul([str UTF8String], 0, 16)];
        [allArray addObject:str1];
    }
    
    [allArray addObject:carNum];
    NSLog(@"allArray:%@",allArray);
    
    Byte byte[17];
    for (int i = 0; i<16; i++) {
        NSString *str = [NSString stringWithFormat:@"%@",allArray[i]];
        byte[i] = str.intValue;
    }
    //授权号(01车牌开，02id开，03车牌+id开)
    //NSString *autoOpen =[UserDefaults valueForKey:[NSString stringWithFormat:@"%@%@",carNum,@"auto"]];
    byte[15] = 01;//20151105修改,只有一种开闸方式，自动//[autoOpen intValue] == 0?3:[autoOpen intValue];//默认设置03
    //NSLog(@"--Auto:------------------%d",[autoOpen intValue]);
    byte[16] =0;
    for(int i= 0;  i<16; i++) byte[16] =  byte[16]^byte[i];
    
    NSData *d=[NSData dataWithBytes:&byte length:17];
    return d;
}


-(BOOL)isHanzi:(unichar)c{
    if (c>=0x4E00 && c<=0x9FA5) {
        return YES;
    }
    return NO;
}

@end
