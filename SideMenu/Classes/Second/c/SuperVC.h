//
//  SuperVC.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardHelper.h"

@interface SuperVC : UIViewController <UIKeyboardDelegate>

{
    UIKeyboardHelper *keyboardHelper;
}

/// 添加单击手势 用于取消键盘
- (void)addTapGestureRecognizer;

@end
