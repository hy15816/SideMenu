//
//  CircleProgressView.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/12.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "CircleProgressView.h"

@interface CircleProgressView ()

@property (nonatomic) CADisplayLink *displayLink;
@property (assign,nonatomic) CGFloat angle;
@property (strong,nonatomic) CAShapeLayer *progressLayer;
@property (assign,nonatomic) CGFloat progress;
@end

@implementation CircleProgressView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (id)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor progressColor:(UIColor *)progressColor lineWidth:(CGFloat)lineWidth{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        _backColor = backColor;
        _progressColor = progressColor;
        self.lineWidth = lineWidth;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  初始化view和控件
 */
- (void)setup{
    
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGesture];
}

/**
 *  设置圆环宽度
 *
 *  @param lineWidth 圆环宽度
 */
- (void)setLineWidth:(CGFloat)lineWidth{
    
    CAShapeLayer *backgroundLayer = [self createRingLayerWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2) radius:CGRectGetWidth(self.bounds) / 2 - lineWidth / 2 lineWidth:lineWidth color:self.backColor];
    _lineWidth = lineWidth;
    [self.layer addSublayer:backgroundLayer];
    _progressLayer = [self createRingLayerWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2) radius:CGRectGetWidth(self.bounds) / 2 - lineWidth / 2 lineWidth:lineWidth color:self.progressColor];
    _progressLayer.strokeEnd = 0;
    [self.layer addSublayer:_progressLayer];
}

- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:- M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineJoinBevel;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}


- (void)setProgress:(CGFloat)progress{
    if (progress == 0) {
        self.progressLayer.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressLayer.strokeEnd = 0;
        });
    }else {
        self.progressLayer.hidden = NO;
        self.progressLayer.strokeEnd = progress;
    }
}

- (void)updateProgressCircle{
    //update progress value

    /*
    self.progress = (float) (self.player.currentTime / self.player.duration);
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(CircularProgressViewDelegate)]) {
        [self.delegate updateProgressViewWithPlayer:self.player];
    }
     */
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self];
    self.angle = [self angleFromStartToPoint:point];
    self.progress = self.angle/(M_PI * 2);
    /*
    self.player.currentTime = self.player.duration * (self.angle / (2 * M_PI));
    if (!self.player.playing) {
        [self play];
    }
    [self.delegate updatePlayOrPauseButton];
     */
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.displayLink.paused = YES;
        CGPoint point = [recognizer locationInView:self];
        self.angle = [self angleFromStartToPoint:point];
        self.progress = self.angle/(M_PI * 2);
        /*
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(CircularProgressViewDelegate)]) {
            [self.delegate updateProgressViewWithPlayer:self.player];
        }
         */
    }
    
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        /*
        self.player.currentTime = self.player.duration * (self.angle / (2 * M_PI));
        if (!self.player.playing) [self play];
        else
            self.displayLink.paused = NO;
        [self.delegate updatePlayOrPauseButton];
         */
        NSLog(@"UIGestureRecognizerStateEnded");
    }
}

//calculate angle between start to point
- (CGFloat)angleFromStartToPoint:(CGPoint)point{
    CGFloat angle = [self angleBetweenLinesWithLine1Start:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
                                                 Line1End:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2 - 1)
                                               Line2Start:CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
                                                 Line2End:point];
    if (CGRectContainsPoint(CGRectMake(0, 0, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)), point)) {
        angle = 2 * M_PI - angle;
    }
    return angle;
}

//calculate angle between 2 lines
- (CGFloat)angleBetweenLinesWithLine1Start:(CGPoint)line1Start
                                  Line1End:(CGPoint)line1End
                                Line2Start:(CGPoint)line2Start
                                  Line2End:(CGPoint)line2End{
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    return acos(((a * c) + (b * d)) / ((sqrt(a * a + b * b)) * (sqrt(c * c + d * d))));
}


@end
