//
//  CircleProgress.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/11.
//  Copyright © 2015年 hyIm. All rights reserved.
//  绘制一个圆环进度条(UIBezierPath)

#import <UIKit/UIKit.h>

@interface CircleProgress : UIView
{
    UILabel *_textLabel;
}
@property (nonatomic) double progress;

@property (nonatomic) NSInteger showText ;
@property (nonatomic) NSInteger roundedHead ;
@property (nonatomic) NSInteger showShadow ;

@property (nonatomic) CGFloat thicknessRatio ;

@property (nonatomic, strong) UIColor *innerBackgroundColor ;
@property (nonatomic, strong) UIColor *outerBackgroundColor ;

@property (nonatomic, strong) UIFont *font ;

@property (nonatomic, strong) UIColor *progressFillColor ;

@property (nonatomic, strong) UIColor *progressTopGradientColor ;
@property (nonatomic, strong) UIColor *progressBottomGradientColor ;

@end
