//
//  RoundProgress.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/11.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "RoundProgress.h"

@interface RoundProgress ()
@property (assign,nonatomic) CGFloat proValue;
@end

@implementation RoundProgress

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (!_percent) {
            self.proValue = 0;
        }
        _width = 0;
    }
    
    return self;
}

- (void)setPercent:(float)percent{
    self.proValue = percent;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [self addArcBackColor];
    [self drawArc];
    [self addCenterBack];
    [self addCenterLabel];
}

- (void)addArcBackColor{
    CGColorRef color = (_arcBackColor == nil) ? [UIColor lightGrayColor].CGColor : _arcBackColor.CGColor;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    
    // Draw the slices.
    CGFloat radius = viewSize.width / 2;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}

- (void)drawArc{
    if (self.proValue == 0 || self.proValue > 1) {
        return;
    }
    
    if (self.proValue == 1) {
        CGColorRef color = (_arcFinishColor == nil) ? [UIColor greenColor].CGColor : _arcFinishColor.CGColor;
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }else{
        
        float endAngle = 2*M_PI*self.proValue;
        
        CGColorRef color = (_arcUnfinishColor == nil) ? [UIColor blueColor].CGColor : _arcUnfinishColor.CGColor;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius,0,endAngle, 0);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }
    
}
/**
 *  中间小圈的颜色(遮挡)
 */
-(void)addCenterBack{
    
    float width = (_width == 0) ? 5 : _width;
    
    CGColorRef color = (_centerColor == nil) ? [UIColor whiteColor].CGColor : _centerColor.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    // Draw the slices.
    CGFloat radius = viewSize.width / 2 - width;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}

/**
 *  中间字体
 */
- (void)addCenterLabel{
    NSString *percent = @"";
    
    float fontSize = 14;
    UIColor *arcColor = [UIColor blueColor];
    if (self.proValue == 1) {
        percent = @"100%";
        fontSize = 14;
        arcColor = (_arcFinishColor == nil) ? [UIColor greenColor] : _arcFinishColor;
        
    }else if(self.proValue < 1 && self.proValue >= 0){
        
        fontSize = 13;
        arcColor = (_arcUnfinishColor == nil) ? [UIColor blueColor] : _arcUnfinishColor;
        percent = [NSString stringWithFormat:@"%0.f%%",self.proValue*100];
        //NSLog(@"percent:%@",percent);
    }
    
    CGSize viewSize = self.bounds.size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize],NSFontAttributeName,arcColor,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
    
    [percent drawInRect:CGRectMake(5, (viewSize.height-fontSize)/2, viewSize.width-10, fontSize)withAttributes:attributes];
}


@end
