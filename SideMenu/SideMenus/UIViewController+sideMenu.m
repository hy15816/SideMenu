//
//  UIViewController+sideMenu.m
//  hiu
//
//  Created by AEF-RD-1 on 15/10/7.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "UIViewController+sideMenu.h"
#import "RESideMenu.h"
@implementation UIViewController (sideMenu)

- (RESideMenu *)sideMenuViewController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[RESideMenu class]]) {
            return (RESideMenu *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark IB Action Helper methods

- (void)presentLeftMenuViewController:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)presentRightMenuViewController:(id)sender
{
    [self.sideMenuViewController presentRightMenuViewController];
}

@end
