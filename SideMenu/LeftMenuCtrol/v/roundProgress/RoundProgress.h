//
//  RoundProgress.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/11.
//  Copyright © 2015年 hyIm. All rights reserved.
//  绘制一个圆环进度条(UIView draw)

#import <UIKit/UIKit.h>

@interface RoundProgress : UIView

//中心颜色
@property (strong, nonatomic)UIColor *centerColor;
//圆环背景色
@property (strong, nonatomic)UIColor *arcBackColor;
//圆环色
@property (strong, nonatomic)UIColor *arcFinishColor;
@property (strong, nonatomic)UIColor *arcUnfinishColor;


//百分比数值（0-1）
@property (assign, nonatomic)float percent;

//圆环宽度
@property (assign, nonatomic)float width;

@end
