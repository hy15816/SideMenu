//
//  AlertView.h
//  ShenMaDiDiClient
//
//  Created by goopai on 14-6-17.
//  Copyright (c) 2014年 LiFei. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *自定义alertView
 */
@class AlertView;
@protocol AlertViewDelegate <NSObject>

- (void)alertView:(AlertView *)alertView selectButtonAtIndex:(NSInteger)selectIndex;

@end

@interface AlertView : UIView

@property (strong, nonatomic) UIImageView *popView;
@property (assign, nonatomic) CGRect popFrame;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UITextView *messageView;
@property (strong, nonatomic) UIButton *leftBotton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIButton *cancelButton;

- (id)initPopViewWithBackImage:(UIImage *)image delegate:(id<AlertViewDelegate>)delegate Title:(NSString *)titleString Message:(NSString *)messageString Buttons:(NSArray *)buttons;

- (void)initLeftButtonBackImage:(NSArray *)arr;
- (void)initRightButtonBackImage:(NSArray *)arr;
- (void)initCancelButtonBackImage:(NSArray *)arr;

- (void)showPopView;

@end



