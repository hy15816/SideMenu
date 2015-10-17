//
//  HYTabBarItem.m
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/10.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

#define DEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)      //设备屏幕宽度
#define DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)    //设备屏幕高度

#import "HYTabBarItem.h"

@implementation HYTabBarItem

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
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

#pragma mark - 覆盖父类在highlighted时的所有操作
- (void)setHighlighted:(BOOL)highlighted {
    //[super setHighlighted:highlighted];
}


#pragma mark - 设置Button内部的image的范围
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.8;
    
    return CGRectMake(0, 0, imageW, imageH);
    
}
#pragma mark - 设置Button内部的title的范围
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height *0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}


#pragma mark - 按钮里，图上文下
-(void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType
{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    //字的高度
    CGSize titleSize = CGSizeMake(self.frame.size.width, 12);
    //设置图片，顶端对齐
    [self.imageView setContentMode:UIViewContentModeTop];
    //图片大小
    self.imageView.frame = CGRectMake((DEVICE_WIDTH/4-image.size.width)/2, 0, image.size.width, image.size.height);
    //imageview背景颜色
    //self.imageView.backgroundColor = RGBACOLOR(48, 182, 247, 1);
    //image缩进
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    //设置字体，中间对齐
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    
    //清除lable背景颜色
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    
    //字体font
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    //[self.titleLabel setFont:[UIFont fontWithName:@"" size:8]];
    
    //[self.titleLabel setTextColor:RGBACOLOR(29, 29, 29, 1)];
    
    //文字缩进
    [self setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height+3,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}



@end
