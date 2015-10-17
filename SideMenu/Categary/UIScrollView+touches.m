//
//  UIScrollView+touches.m
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/28.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

#import "UIScrollView+touches.h"

@implementation UIScrollView (touches)

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //[[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //[[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //[[self nextResponder] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}
@end
