//
//  ViewController.h
//  hiu
//
//  Created by AEF-RD-1 on 15/9/30.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "HYTabBarController.h"

@interface RootViewController : HYTabBarController
/**
 *  是显示二级页面
 */
@property (assign,nonatomic) BOOL isShowSecondVC;

/**
 *  将要显示的页面index
 */
@property (assign,nonatomic) NSInteger isPushIndex;

@end

