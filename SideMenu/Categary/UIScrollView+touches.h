//
//  UIScrollView+touches.h
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/28.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (touches)

//重载方法，使类再使用有滚动视图的view中可以响应touches事件,例：ReadBookVC.m
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
