//
//  AlertView.m
//  ShenMaDiDiClient
//
//  Created by goopai on 14-6-17.
//  Copyright (c) 2014年 LiFei. All rights reserved.
//



#import "AlertView.h"

#define DEVICE_W ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_H ([UIScreen mainScreen].bounds.size.height)

@interface AlertView ()

@property (strong, nonatomic) id<AlertViewDelegate>delegate;

@end

@implementation AlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.frame = CGRectMake(0, 0, DEVICE_W, DEVICE_H);
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
}

- (id)initPopViewWithBackImage:(UIImage *)image delegate:(id<AlertViewDelegate>)delegate Title:(NSString *)titleString Message:(NSString *)messageString Buttons:(NSArray *)buttons
{
    self = [super init];
    if (self) {
        [self initView];
    }
    
    if (delegate) {
        self.delegate = delegate;
    }
    
    CGSize titleSize = [titleString boundingRectWithSize:CGSizeMake(self.frame.size.width-60, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    CGSize messageSize = [messageString boundingRectWithSize:CGSizeMake(DEVICE_W - 60, 180) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopView)];
    tap.numberOfTapsRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    self.popFrame = CGRectMake(10,self.center.y - (100+titleSize.height+messageSize.height)/2 - 40, DEVICE_W - 20, 100+titleSize.height+messageSize.height);
    self.popView = [[UIImageView alloc] initWithFrame:self.popFrame];
    self.popView.userInteractionEnabled = YES;
    self.popView.image = image;
    self.popView.alpha = 0;
    
    [self addSubview:self.popView];
    
    if (titleString.length>0) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.popFrame.size.width - 40, titleSize.height)];
        self.title.textColor = [UIColor blackColor];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = [UIFont systemFontOfSize:17];
        self.title.text = titleString;
        self.title.numberOfLines = 2;
        [self.popView addSubview:self.title];
    }
    
    if (messageString.length>0) {
        if (titleString.length>0)
        {
            self.messageView = [[UITextView alloc] initWithFrame:CGRectMake(20, 50, self.popFrame.size.width - 40, messageSize.height+10)];
        }
        else
        {
            self.messageView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, self.popFrame.size.width - 40, messageSize.height)];
            self.messageView.scrollsToTop = YES;
        }
        self.messageView.editable = NO;
        self.messageView.backgroundColor = [UIColor clearColor];
        self.messageView.textAlignment = NSTextAlignmentCenter;
        self.messageView.textColor = [UIColor grayColor];
        self.messageView.font = [UIFont systemFontOfSize:14];
        self.messageView.text = messageString;
        [self.popView addSubview:self.messageView];
    }
    
    if (buttons.count>1) {
        //左边按钮
        self.leftBotton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.popFrame.size.height - 50, (self.popFrame.size.width - 50)/2, 38)];
        [self.leftBotton setTitle:[buttons objectAtIndex:0] forState:UIControlStateNormal];
        [self.leftBotton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.leftBotton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.leftBotton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.leftBotton setTag:1];
        [self.leftBotton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.popView addSubview:self.leftBotton];
        
        // 右边按钮
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake((self.popFrame.size.width + 10)/2, self.popFrame.size.height - 50, (self.popFrame.size.width - 50)/2, 38)];
        [self.rightButton setTitle:[buttons objectAtIndex:1] forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.rightButton setTag:2];
        [self.rightButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.popView addSubview:self.rightButton];
    }
    else
    {
        //取消按钮
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.popFrame.size.height - 50, self.popFrame.size.width - 40, 38)];
        [self.cancelButton setTitle:[buttons objectAtIndex:0] forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.cancelButton setTag:0];
        [self.cancelButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.popView addSubview:self.cancelButton];
    }
    
    return self;
}

- (void)tapPopView{
    
    [self dismissPopView];
}
- (void)selectButton:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(alertView:selectButtonAtIndex:)]) {
        [self.delegate alertView:self selectButtonAtIndex:sender.tag];
    }
    [self dismissPopView];
}

#pragma mark ---------展现和隐藏-----------
- (void)showPopView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.popView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)dismissPopView
{
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.popView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}

#pragma mark ---------设置按钮背景-----------
- (void)initLeftButtonBackImage:(NSArray *)arr
{
    [self.leftBotton setBackgroundImage:[UIImage imageNamed:[arr objectAtIndex:0]] forState:UIControlStateNormal];
    [self.leftBotton setBackgroundImage:[UIImage imageNamed:[arr objectAtIndex:1]] forState:UIControlStateHighlighted];
}

- (void)initRightButtonBackImage:(NSArray *)arr
{
    [self.rightButton setBackgroundImage:[UIImage imageNamed:[arr objectAtIndex:0]] forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:[arr objectAtIndex:1]] forState:UIControlStateHighlighted];
}

- (void)initCancelButtonBackImage:(NSArray *)arr
{
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:[arr objectAtIndex:0]] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:[arr objectAtIndex:1]] forState:UIControlStateHighlighted];
}

@end
