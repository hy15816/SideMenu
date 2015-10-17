//
//  ProjBaseSecVC.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/13.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

typedef enum{
    ShowProgressTypeDefault,
    ShowProgressTypeOther
} ShowProgressType;

#import <UIKit/UIKit.h>

@interface ProjBaseSecVC : UIViewController
{
    UIProgressView *proViewSec;
}
/**
 *  显示progressView，
 */
-(void)showProViewSec:(ShowProgressType)type;

/**
 *  改变进度条的值
 *
 *  @param proValue progress.value
 */
-(void)changeProValueSec:(CGFloat)proValue;



@end
