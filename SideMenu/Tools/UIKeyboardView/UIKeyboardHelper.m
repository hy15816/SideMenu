//
//  UIKeyboard.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "UIKeyboardHelper.h"

static CGFloat kboardHeight = 254.0f;
static CGFloat keyBoardToolbarHeight = 38.0f;
static CGFloat spacerY = 6.0f;
static CGFloat viewFrameY = 0;

@interface UIKeyboardHelper ()

- (void)animateView:(BOOL)isShow textField:(id)textField heightforkeyboard:(CGFloat)kheight;
- (void)addKeyBoardNotification;
- (void)removeKeyBoardNotification;
- (void)checkBarButton:(id)textField;
- (id)firstResponder:(UIView *)navView;
- (NSArray *)allSubviews:(UIView *)theView;
- (void)resignKeyboard:(UIView *)resignView;

@end

@implementation UIKeyboardHelper

// 监听键盘隐藏和显示事件
- (void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 注销监听事件
- (void)removeKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 计算当前键盘的高度
-(void)keyboardWillShowOrHide:(NSNotification *)notification
{
    NSValue *keyboardBoundsValue;
    
    keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    [keyboardBoundsValue getValue:&keyboardBounds];
    BOOL isShow = [[notification name] isEqualToString:UIKeyboardWillShowNotification] ? YES : NO;
    if ([self firstResponder:objectView])
    {
        [self animateView:isShow textField:[self firstResponder:objectView]
        heightforkeyboard:keyboardBounds.size.height];
    }
}

#pragma mark - 
//输入框上移防止键盘遮挡
- (void)animateView:(BOOL)isShow textField:(id)textField heightforkeyboard:(CGFloat)kheight
{
    kboardHeight = kheight;
    [self checkBarButton:textField];
    CGRect rect = objectView.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if (isShow) {
        if ([textField isKindOfClass:[UITextField class]]) {
            UITextField *newText = ((UITextField *)textField);
            CGPoint textPoint = [newText convertPoint:CGPointMake(0, newText.frame.size.height + spacerY) toView:objectView];
            if (rect.size.height - textPoint.y < kheight)
                rect.origin.y = rect.size.height - textPoint.y - kheight + viewFrameY;
            else rect.origin.y = viewFrameY;
        }
        else {
            UITextView *newView = ((UITextView *)textField);
            CGPoint textPoint = [newView convertPoint:CGPointMake(0, newView.frame.size.height + spacerY) toView:objectView];
            if (rect.size.height - textPoint.y < kheight)
                rect.origin.y = rect.size.height - textPoint.y - kheight + viewFrameY;
            else rect.origin.y = viewFrameY;
        }
    }
    else rect.origin.y = viewFrameY;
    objectView.frame = rect;
    [UIView commitAnimations];
}

//设置previousBarItem或nextBarItem是否允许点击
- (void)checkBarButton:(id)textField{
    
    UITextField *field = (UITextField *)textField;
    field.enabled = YES;
}
//输入框获得焦点
- (id)firstResponder:(UIView *)navView {
    
    for (id aview in [self allSubviews:navView]) {
        if ([aview isKindOfClass:[UITextField class]] && [(UITextField *)aview isFirstResponder]) {
            return (UITextField *)aview;
        }
        else if ([aview isKindOfClass:[UITextView class]] && [(UITextView *)aview isFirstResponder]) {
            return (UITextView *)aview;
        }
    }
    return nil;
}

//找出所有的subview
- (NSArray *)allSubviews:(UIView *)theView {
    NSArray *results = [theView subviews];
    for (UIView *eachView in [theView subviews]) {
        NSArray *riz = [self allSubviews:eachView];
        if (riz) {
            results = [results arrayByAddingObjectsFromArray:riz];
        }
    }
    //NSLog(@"resaultVC:%@",results);
    return results;
}

//输入框失去焦点，隐藏键盘
- (void)resignKeyboard:(UIView *)resignView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - KeyboardViewDelegate
- (void)keyboardView:(KeyboardBar *)view didSelectIndex:(NSInteger)index{
    NSInteger buttonTag = index;
    NSMutableArray *textFieldArray=[NSMutableArray arrayWithCapacity:10];
    for (id aview in [self allSubviews:objectView]) {
        if ([aview isKindOfClass:[UITextField class]] && ((UITextField*)aview).userInteractionEnabled && ((UITextField*)aview).enabled) {
            [textFieldArray addObject:(UITextField *)aview];
        }
        else if ([aview isKindOfClass:[UITextView class]] && ((UITextView*)aview).userInteractionEnabled && ((UITextView*)aview).editable) {
            [textFieldArray addObject:(UITextView *)aview];
        }
    }
    for (int i = 0; i < [textFieldArray count]; i++) {
        id textField = [textFieldArray objectAtIndex:i];
        if ([textField isKindOfClass:[UITextField class]]) {
            textField = ((UITextField *)textField);
        }
        else {
            textField = ((UITextView *)textField);
        }
        if ([textField isFirstResponder]) {
            if (buttonTag == 1) {
                if (i > 0) {
                    [[textFieldArray objectAtIndex:--i] becomeFirstResponder];
                    [self animateView:YES textField:[textFieldArray objectAtIndex:i] heightforkeyboard:kboardHeight];
                }
            }
            else if (buttonTag == 2) {
                if (i < [textFieldArray count] - 1) {
                    [[textFieldArray objectAtIndex:++i] becomeFirstResponder];
                    [self animateView:YES textField:[textFieldArray objectAtIndex:i] heightforkeyboard:kboardHeight];
                }
            }
        }
    }
    if (buttonTag == 3) 
        [self resignKeyboard:objectView];

}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self checkBarButton:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(alttextFieldDidEndEditing:)])
    {
        [self.delegate alttextFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([self.delegate respondsToSelector:@selector(alttextViewEditing:shouldChangeCharactersInRange:replacementString:)])
    {
        return [self.delegate alttextViewEditing:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(alttextFieldShouldBeginEditing:)])
    {
        return [self.delegate alttextFieldShouldBeginEditing:textField];
    }
    return YES;
}

#pragma mark - UITextView delegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(alttextViewDidEndEditing:)])
    {
        [self.delegate alttextViewDidEndEditing:textView];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([self.delegate respondsToSelector:@selector(alttextViewDidBeginEditing:)])
    {
        [self.delegate alttextViewDidBeginEditing:textView];
    }
}

@end


//============UIKeyboardHelperCreation===============
@implementation UIKeyboardHelper (UIKeyboardHelperCreation)

#pragma mark - UIKeyboard (UIKeyboardCreation)
- (id)initWithKeyboardDelegate:(id <UIKeyboardDelegate>)delegateObject {
    if (self = [super init])
    {
        self.delegate = delegateObject;
        if ([self.delegate isKindOfClass:[UIViewController class]])
        {
            objectView = [(UIViewController *)[self delegate] view];
        }
        else if ([self.delegate isKindOfClass:[UIView class]])
        {
            objectView = (UIView *)[self delegate];
        }
        viewFrameY = objectView.frame.origin.y;
        [self addKeyBoardNotification];
    }
    return self;
}

@end


//============UIKeyboardHelperAction================
@implementation UIKeyboardHelper (UIKeyboardHelperAction)

#pragma mark - UIKeyboard (UIKeyboardAction)
- (void)addToolBar{
    
    keyboardToolbar = [[KeyboardBar alloc] initWithFrame:CGRectMake(0, 0, objectView.frame.size.width, keyBoardToolbarHeight)];
    keyboardToolbar.delegate = self;
    for (id aview in [self allSubviews:objectView])
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            ((UITextField *)aview).inputAccessoryView = keyboardToolbar;
            ((UITextField *)aview).delegate = self;
        }
        else if ([aview isKindOfClass:[UITextView class]])
        {
            ((UITextView *)aview).inputAccessoryView = keyboardToolbar;
            ((UITextView *)aview).delegate = self;
        }
    }

}

@end
