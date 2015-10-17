//
//  HYTabBarView.m
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/10.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

/** r red   0-255 g green 0-255 b blue  0-255 a alpha 0-1 */
#define COLORRGB(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#import "HYTabBarView.h"
#import "HYTabBarItem.h"

@interface HYTabBarView ()
{
    HYTabBarItem *curItem;
}
@end

@implementation HYTabBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)addItemIcon:(NSString *)norma select:(NSString *)selectIcon title:(NSString *)title selectTitlt:(NSString *)selectTitle
{
    HYTabBarItem *item = [[HYTabBarItem alloc] init];
    [item setImage:[UIImage imageNamed:norma] withTitle:title forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:selectIcon] withTitle:selectTitle forState:UIControlStateSelected];
    [item setTitleColor:COLORRGB(100, 156, 192,1) forState:UIControlStateSelected];
    [item setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:item];
    NSInteger count = self.subviews.count;
    CGFloat height = self.frame.size.height; // 高度
    CGFloat width  = self.frame.size.width / count; // 宽度
    //默认选中第一个
    if (count ==1) {
        [self itemClick:item];
    }
    //调整item的frame
    for (int i=0; i<count; i++) {
        HYTabBarItem *BarItem = self.subviews[i];
        BarItem.tag = i;
        BarItem.frame = CGRectMake(width*i, 0, width, height);
    }
}


-(void)itemClick:(HYTabBarItem *)item{
    
    if ([self.delegate respondsToSelector:@selector(tabBarView:fromItem:toItem:)]) {
        [self.delegate tabBarView:self fromItem:curItem.tag toItem:item.tag];
    }
    
    curItem.selected = NO;
    item.selected = YES;
    curItem = item;
    
}
@end
