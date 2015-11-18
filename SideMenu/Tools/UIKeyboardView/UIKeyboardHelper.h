//
//  UIKeyboard.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardBar.h"

@protocol UIKeyboardDelegate <NSObject>
@optional
- (BOOL)alttextFieldShouldBeginEditing:(UITextField *)textField;
- (void)alttextFieldDidEndEditing:(UITextField *)textField;
- (BOOL)alttextViewEditing:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)alttextViewDidEndEditing:(UITextView *)textView;
- (void)alttextViewDidBeginEditing:(UITextView *)textView;

@end

@interface UIKeyboardHelper : NSObject <KeyboardViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    CGRect keyboardBounds;
    KeyboardBar *keyboardToolbar;
    UIView *objectView;
}
@property (assign,nonatomic) id<UIKeyboardDelegate> delegate;
@property (assign,nonatomic) BOOL unableBarItem;

@end

//==========UIKeyboardHelperCreation==============
@interface UIKeyboardHelper (UIKeyboardHelperCreation)

- (id)initWithKeyboardDelegate:(id <UIKeyboardDelegate>)delegateObject;

@end

//==========UIKeyboardHelperAction================
@interface UIKeyboardHelper (UIKeyboardHelperAction)
- (void)addToolBar;

@end

