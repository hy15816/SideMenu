//
//  common.h
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/14.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

//==================常用值=====================
#define kDEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)      //设备屏幕宽度
#define kDEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)    //设备屏幕高度
#define kUSERDFS [NSUserDefaults standardUserDefaults]
#define kHYTabBarHeight 49.f        //tabbar高度
/** 本地路径*/
#define kDocumentPath       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPersonsPlistPath    [kDocumentPath stringByAppendingPathComponent:@"persons.plist"]
#define kPlistPath(fileName) [kDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]]
#define kMainStoryboard     [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define kLeftStoryboard     [UIStoryboard storyboardWithName:@"LeftCtrol" bundle:nil]


/** r red   0-255 g green 0-255 b blue  0-255 a alpha 0-1 */
#define kCOLORRGB(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

/** value 0xFFFFFF*/
#define kCOLORVALUE(value,a) [UIColor colorWithRed:((value & 0xFF0000) >> 16)/255.f green:((value & 0xFF00) >> 8)/255.f blue:(value & 0xFF)/255.0 alpha:a]
/**
 *  随机颜色
 */
#define kCOLORRANDOM [UIColor colorWithRed:(arc4random() % 255)/255.f green:(arc4random() % 255)/255.f blue:(arc4random() % 255)/255.f alpha:1];


//==================地址=======================
#define kGetURLImage    @"http://img5.imgtn.bdimg.com/it/u=3279029117,1242220858&fm=21&gp=0.jpg"       //图片网址
#define kLOGINURL        @"http://112.74.128.144:8189/AnerfaBackstage/login/login.do"                    //登录
#define kOPCARINFOURL    @"http://112.74.128.144:8189/AnerfaBackstage/addLicensePlate/addLicensePlate.do"    //操作车牌

#define kFirstLaunch    @"firstLaunch5"

#define kDFUSERNAME  [kUSERDFS valueForKey:kUSERNAME]
#define kLOGINSTATE  @"loginState"   //登录状态
#define kUSERNAME    @"user_name"    //用户名
#define kUSERPWD     @"password"     //密码
#define kISPLAYERMUSIC @"isPlayeringMusicName"  //正在播放的歌曲

#define kTAG_USER_ICON  20  //头像
#define kTAG_USER_NAME  21  //用户名
#define kTAG_USER_SIGN  22  //签名


#define kShowRemoteNotification @"kShowRemoteNotification"  //推送通知
#define kMyIconDidChanged       @"kmyIconDidChanged"        //头像已改变通知
#define kMyHeadPortraitName @"my_icon_image"        //我的头像













