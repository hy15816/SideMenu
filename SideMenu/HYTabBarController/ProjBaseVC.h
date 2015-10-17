//
//  ProjBaseVC.h
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/23.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProjBaseVCDelegate <NSObject>
@optional
-(void)showLeftView:(UIViewController *)control;
-(void)showLoginView:(UIViewController *)control;

@end

@interface ProjBaseVC : UIViewController

@property (assign,nonatomic) id<ProjBaseVCDelegate> delegate;

-(void)abc;


@end
