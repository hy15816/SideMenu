//
//  UIKeyboardView.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//  一个view，他加载在键盘的view.origin.y 之上，上面显示上一项、下一项、完成；按钮，控制super view 上的控件成为第一响应者，如textField，同时控制field的frame

#import <UIKit/UIKit.h>

@class KeyboardBar;
@protocol KeyboardViewDelegate <NSObject>

- (void)keyboardView:(KeyboardBar *)view didSelectIndex:(NSInteger)index;

@end

@interface KeyboardBar : UIView
{
    
    UIToolbar *keyboardToolbar;
}
@property (assign,nonatomic) id<KeyboardViewDelegate> delegate;

@end


//====================KeyboardBarAction==================
@interface KeyboardBar (KeyboardBarAction)

- (UIBarButtonItem *)itemForIndex:(NSInteger)itemIndex;

@end