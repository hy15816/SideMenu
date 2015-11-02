//
//  PopView.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/10.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "PopView.h"

@interface PopView ()

@property (strong,nonatomic) UIView *backgroundView;

@end

@implementation PopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (PopView *)initWithViewItems:(NSArray *)views frame:(CGRect)frame {
    
    self = [[PopView alloc] initWithFrame:frame];
    
//    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
//    self.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
//    [self addGestureRecognizer:tapGesture];

    
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    for (int i=0; i<views.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, frame.size.height/views.count *i+5, frame.size.width, frame.size.height/views.count-5);
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[views objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 10000+i;
        [button addTarget:self action:@selector(popViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //lebel 线条
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(button.frame), frame.size.width-10, .5)];
        lab.backgroundColor = [UIColor grayColor];
        if (i == views.count-1) {//最后一行不要了
            lab.alpha = 0;
        }
        [self addSubview:lab];
        [self addSubview:button];
        
    }
    
    return self;
}

- (void)showPopInView:(UIView *)view{
    
    
}

- (void)tappedCancel{
    
}

-(void)popViewButtonClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(popViewItemClick:)]) {
        [self.delegate popViewItemClick:btn];
    }
    
}

@end
