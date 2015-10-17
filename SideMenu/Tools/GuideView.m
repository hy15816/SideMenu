//
//  GuideController.m
//  TXBoxNew
//
//  Created by Naron on 15/6/24.
//  Copyright (c) 2015年 playtime. All rights reserved.
//  简单的引导页

#define disMissTime 3       //3秒

#import "GuideView.h"
#import <ImageIO/ImageIO.h>

@interface GuideView ()<UIScrollViewDelegate>

@property (assign,nonatomic) NSInteger views;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;

@end

@implementation GuideView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        //imagesArray = [[NSMutableArray alloc] init];
    }
    return self;
    
}

-(void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];

}

-(void) setImages:(NSMutableArray *)imgsArray;
{
    CGFloat wid = self.frame.size.width;
    CGFloat hig = self.frame.size.height;
     _views = imgsArray.count;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, wid, hig)];
    [_scrollView setContentSize:CGSizeMake(wid * _views, 0)];
    [_scrollView setPagingEnabled:YES];  //视图整页显示
    [_scrollView setBounces:YES]; //避免弹跳效果,避免把根视图露出来
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
//    [_scrollView setContentInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,hig-40 ,wid, 21)];
    _pageControl.backgroundColor=[UIColor clearColor];
    _pageControl.numberOfPages=_views;
    _pageControl.currentPage=0;
    [_pageControl addTarget:self action:@selector(CurPageChangeds:) forControlEvents:UIControlEventValueChanged];
    
    //图片views
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownInimage)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOnImage)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    for (int i=0; i<_views; i++) {

        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(wid*i, 0, wid, hig)];
        [imageview setImage:[UIImage imageNamed:imgsArray[i]]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((imageview.frame.size.width - imageview.frame.size.width/3)/2, imageview.frame.size.height-80, imageview.frame.size.width/3, 35);
        [button setTitle:@"立即体验" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(touchDownInimage) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = .5;
        
        //如果当前是最后一个view，
        if (i == _views-1) {
            imageview.userInteractionEnabled = YES;
            [imageview addSubview:button];
            //[self initAnimatedWithFileName:@"line" andType:@"gif" view:view];
            [imageview addGestureRecognizer:tapGR];
            [imageview addGestureRecognizer:swipe];
        }
        [_scrollView addSubview:imageview];
    }

    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
}


//隐藏
- (void)touchDownInimage
{
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        self.alpha = 0;
        
    } completion:^(BOOL finished){
        NSLog(@"guide view finished");
    }];
    
}

-(void)swipeOnImage{
    [self touchDownInimage];
}

-(void)CurPageChangeds:(UIPageControl *)pageCtrol{
    //点击小点，显示相应的view(图片)
}

//滚动图片，改变小点的显示位置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(_scrollView.contentOffset.x) / _scrollView.frame.size.width;
    _pageControl.currentPage = index;

    if (index == _views-1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disMissTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //一次性执行
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self touchDownInimage];
            });
            
        });
    }
}

/*
#pragma mark -- 加载gif图片
-(void)initAnimatedWithFileName :(NSString *)fileName andType:(NSString *)type view:(UIView *)vview
{
    //解码图片
    NSString *imagePath =[[NSBundle mainBundle] pathForResource:fileName ofType:type];
    CGImageSourceRef  cImageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:imagePath], NULL);
    //读取动画的每一帧
    size_t imageCount = CGImageSourceGetCount(cImageSource);
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSMutableArray *times = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:imageCount];
    
    //显示时间
    float totalTime = 0;
    CGSize size;
    for (size_t i = 0; i < imageCount; i++) {
        CGImageRef cgimage= CGImageSourceCreateImageAtIndex(cImageSource, i, NULL);
        [images addObject:(__bridge id)cgimage];
        CGImageRelease(cgimage);
        
        NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(cImageSource, i, NULL);
        NSDictionary *gifProperties = [properties valueForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        NSString *gifDelayTime = [gifProperties valueForKey:(__bridge NSString* )kCGImagePropertyGIFDelayTime];
        [times addObject:gifDelayTime];
        totalTime += [gifDelayTime floatValue];
        
        size.width = [[properties valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
        size.height = [[properties valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
    }
    
    float currentTime = 0;
    for (size_t i = 0; i < times.count; i++) {
        float keyTime = currentTime / totalTime;
        [keyTimes addObject:[NSNumber numberWithFloat:keyTime]];
        currentTime += [[times objectAtIndex:i] floatValue];
    }
    
    //执行CAKeyFrameAnimation动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setValues:images];
    [animation setKeyTimes:keyTimes];
    animation.duration = totalTime;
    animation.repeatCount = HUGE_VALF;
    
    [vview.layer addAnimation:animation forKey:@"gifAnimation"];
 
}

*/
@end
