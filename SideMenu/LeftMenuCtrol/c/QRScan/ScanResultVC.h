//
//  ScanResultVC.h
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/15.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//
typedef enum{
    ShowTypeText,
    ShowTypeWebView
} ShowType;


#import "ProjBaseSecVC.h"

@interface ScanResultVC : ProjBaseSecVC
/**
 *  将要显示的类型
 */
@property (assign,nonatomic) ShowType showType;
/**
 *  文字/网址
 */
@property (strong,nonatomic) NSString *urlString;
@end
