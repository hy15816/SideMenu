//
//  UIViewController+sideMenu.h
//  hiu
//
//  Created by AEF-RD-1 on 15/10/7.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface UIViewController (sideMenu)

@property (strong,readonly,nonatomic) RESideMenu *sideMenuViewController;


- (void)presentLeftMenuViewController:(id)sender;
- (void)presentRightMenuViewController:(id)sender;

@end
