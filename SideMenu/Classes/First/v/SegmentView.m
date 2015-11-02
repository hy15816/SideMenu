//
//  SegmentView.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/30.
//  Copyright © 2015年 hyIm. All rights reserved.
//


#import "SegmentView.h"


typedef NS_OPTIONS(NSUInteger, SwipeDirection) {
    SwipeDirectionRight = 0,
    SwipeDirectionLeft  = 1 ,
    
};

@interface SegmentView ()
{
    UIButton *currentButton;
    void (^updateSelfFrame) (UIFont *font);
}
/**
 *  底view 底视图
 */
@property (strong,nonatomic) UIView *backgroundView;
/**
 *  移动的方块
 */
@property (strong,nonatomic) UIView *moveView;
/**
 *  移动的方块的默认颜色
 */
@property (strong,nonatomic) UIColor *DFMoveViewBgColor;
/**
 *  item 的title 的font
 */
@property (strong,nonatomic) UIFont *DFItemsTitleFont;

/**
 *  单个 item的width
 */
@property (assign,nonatomic) CGFloat itemWidth;


@property (assign,nonatomic) id<SegmentViewDelegate>delegate;

@end

@implementation SegmentView

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
        //
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SegmentViewDelegate>)delegate items:(NSArray *)items font:(UIFont *)font{
    
    self.DFMoveViewBgColor = [UIColor greenColor];
    self.DFItemsTitleFont = [UIFont systemFontOfSize:14];
    if (font) {
        self.DFItemsTitleFont = font;
    }
    //一个item的width
    self.itemWidth = [self getLongObj:items];
    //计算self需要的宽度
    CGFloat selfWidth = self.itemWidth *items.count;
    self = [self initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, selfWidth, frame.size.height)];
    if (self) {
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        //底视图
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,selfWidth , frame.size.height)];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundView.userInteractionEnabled = YES;
        self.backgroundView.layer.cornerRadius = 3;
        self.backgroundView.layer.borderColor = [UIColor blackColor].CGColor;
        self.backgroundView.layer.borderWidth = .5;
        self.backgroundView.layer.masksToBounds = YES;  //是添加在self.backgroundView 上的view也会裁剪成为圆角
        [self addSubview:self.backgroundView];
        
        /*
        //swipe
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOnbackgroundView:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.backgroundView addGestureRecognizer:swipeLeft];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOnbackgroundView:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.backgroundView addGestureRecognizer:swipeRight];
        */
        
        //滑动视图
        self.moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWidth/items.count, frame.size.height)];
        self.moveView.backgroundColor = self.DFMoveViewBgColor;
        [self.backgroundView addSubview:self.moveView];
        
        //items
        CGFloat btnW = selfWidth/items.count;
        for (int i=0; i<items.count; i++) {
            [self createButton:CGRectMake(i*btnW, 0, btnW, frame.size.height) title:items[i] tag:kTAG_ITEM_BUTTON+i];
        }
    }
    
    return self;
}

-(void)setMoveViewColor:(UIColor *)moveViewColor{
    self.DFMoveViewBgColor = moveViewColor;
    self.moveView.backgroundColor = self.DFMoveViewBgColor;
}

#pragma mark - UISwipeGestureRecognizer
- (void)swipeOnbackgroundView:(UISwipeGestureRecognizer *)swipe{
    if (swipe.state == UIGestureRecognizerStateEnded) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            //
            NSLog(@"swipe Left");
            [self changeMoveViewOrigin:SwipeDirectionLeft];
        }
        if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            NSLog(@"swipe Right");
            [self changeMoveViewOrigin:SwipeDirectionRight];
        }
    }
    
}

/**
 *  改变滑块的位置
 *
 *  @param direction 手势滑动方向(左/右)
 */
- (void)changeMoveViewOrigin:(SwipeDirection)direction{
    
    CGFloat mx = self.moveView.frame.origin.x;
    CGFloat my = self.moveView.frame.origin.y;
    CGFloat mw = self.moveView.frame.size.width;
    CGFloat mh = self.moveView.frame.size.height;
    [UIView animateWithDuration:.25 animations:^{
        //左
        if (direction == SwipeDirectionLeft) {
            if (mx <= 0) {
                return;
            }
            if (mx > 0) {
                self.moveView.frame = CGRectMake(mx-mw, my, mw, mh);
            }
            
        }
        
        //右
        if (direction == SwipeDirectionRight) {
            if (mx <= 0) {
                self.moveView.frame = CGRectMake(mx+mw, my, mw, mh);;
            }
            if (mx > 0) {
                if (mx == self.frame.size.width - mw) {
                    return;
                }
                self.moveView.frame = CGRectMake(mx+mw, my, mw, mh);
                
            }
        }
        //改变title颜色
        NSInteger tag = mx/mw;
        UIButton *btn = (UIButton *)[self viewWithTag:kTAG_ITEM_BUTTON + tag];
        currentButton.selected = NO;
        btn.selected = YES;
        currentButton = btn;
        //delegate
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(segmentView:didSelectIndex:)]) {
                [self.delegate segmentView:self didSelectIndex:btn.tag];
            }
        }

    }];
    
}

/**
 *  获取数组中item字符串中长度最长的那个，根据[string boundingRectWithSize:options:attributes:context:].size 获取size.width,而不是简单的获取string长度
 *
 *  @param array NSArray
 *
 *  @return MAX(item.bounds.size.width) + 10
 */
- (CGFloat)getLongObj:(NSArray *)array{
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    for (int i=0; i<array.count; i++) {
        NSString *string = array[i];
        
        CGSize stringSize = [string boundingRectWithSize:CGSizeMake(self.frame.size.width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.DFItemsTitleFont} context:nil].size;
        CGFloat w = stringSize.width;
        
        [mutArray addObject:[NSString stringWithFormat:@"%f",w]];
    }
    
    //比较数组元素大小
    NSArray *a = [mutArray sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"[[a lastObject] floatValue]:%f",[[a lastObject] floatValue]);
    return [[a lastObject] floatValue] +10;
}
- (void)createButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.exclusiveTouch = YES;
    [btn setTitle:title  forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    btn.titleLabel.font = self.DFItemsTitleFont;
    btn.tag = tag;
    [btn addTarget:self action:@selector(segmentItemClick:) forControlEvents:UIControlEventTouchUpInside];
    if (tag == kTAG_ITEM_BUTTON + 0) {
        currentButton.selected = NO;
        btn.selected = YES;
        currentButton = btn;
    }
    
    [self.backgroundView addSubview:btn];
}

#pragma mark - SegmentView Action

- (void)segmentItemClick:(UIButton *)btn{
    //改变字体颜色
    currentButton.selected = NO;
    btn.selected = YES;
    currentButton = btn;
    
    //移动moveView
    [UIView animateWithDuration:.25 animations:^{
        
        self.moveView.frame = btn.frame ;//CGRectMake(btn.tag * btn.frame.size.width, 0, btn.frame.size.width, btn.frame.size.height);
        
    }];
    
    //delegate
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(segmentView:didSelectIndex:)]) {
            [self.delegate segmentView:self didSelectIndex:btn.tag];
        }
    }
}



@end
