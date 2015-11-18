//
//  MyDynamicCell.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//


#define kTAG_BUTTON_IPHONE_IDENTIFY  151109     //phone标识
#define kTAG_BUTTON_GOOD             151110     //点赞
#define kTAG_BUTTON_COMMENT          151111     //评论
#define kTAG_BUTTON_SHARE            151112     //分享
#define kTAG_BUTTON_READ_COUNT       151113     //浏览次数
#define kTAG_IMAGEV_USER             151114     //头像
#define kTAG_IMAGEV_DIAMOND          151115     //是某钻
#define kTAG_IMAGEV_ZONE_LEVER       151116     //空间等级

#import "MyDynamicCell.h"

@implementation MyDynamicCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnyViews:)];
    tap.numberOfTapsRequired = 1;
    
    self.userIconImageView.userInteractionEnabled = YES;
    self.isYelloDiamondImgv.userInteractionEnabled = YES;
    self.zoneLevelImgv.userInteractionEnabled = YES;

    [self.userIconImageView addGestureRecognizer:tap];
    [self.isYelloDiamondImgv addGestureRecognizer:tap];
    [self.zoneLevelImgv addGestureRecognizer:tap];
    
    
    //
    [self.iphoneIDFBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.readCountBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.goodBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)tapAnyViews:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(myDynamiccell:tapViewsTag:)]) {
            if (self.userIconImageView) {
                [self.delegate myDynamiccell:self tapViewsTag:kTAG_IMAGEV_USER];
            }
            if (self.isYelloDiamondImgv) {
                [self.delegate myDynamiccell:self tapViewsTag:kTAG_IMAGEV_DIAMOND];
            }
            if (self.zoneLevelImgv) {
                [self.delegate myDynamiccell:self tapViewsTag:kTAG_IMAGEV_ZONE_LEVER];
            }
        }
        
    }
}

- (void)setImagesArray:(NSMutableArray *)imagesArray{

    if (imagesArray.count <= 0) {
        self.messageImageViews.frame = CGRectZero;
        return;
    }
    if (imagesArray.count == 1) {
        UIImage *image = [UIImage imageNamed:[imagesArray objectAtIndex:0]];
        NSLog(@"%f,%f",image.size.width,image.size.height);
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        imgv.image = [UIImage imageNamed:[imagesArray objectAtIndex:0]];
        self.messageImageViews.frame  = CGRectMake(self.messageImageViews.frame.origin.x, self.messageImageViews.frame.origin.y, imgv.frame.size.width, imgv.frame.size.height);
        [self.messageImageViews addSubview:imgv];
        [self layoutIfNeeded];
    }
    
    if (imagesArray.count ==2) {
        for (int i=0; i<2; i++) {
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(i *self.messageImageViews.frame.size.width/2, 0, self.messageImageViews.frame.size.width/2, self.messageImageViews.frame.size.height/2)];
            imgv.image = [UIImage imageNamed:[self.imagesArray objectAtIndex:i]];
            [self.messageImageViews addSubview:imgv];
        }
        
    }
    //i>=3,if(i>9) i=9
    NSInteger loops =imagesArray.count;
    if (imagesArray.count >=3 ) {
        if (imagesArray.count >9) {
            loops = 9;
        }
        NSInteger numberOfRows = 3;
        NSInteger marginLeft = 5;
        NSInteger marginTops = 5;
        CGFloat viewW = (self.messageImageViews.frame.size.width - marginLeft *(numberOfRows+1))/numberOfRows;
        CGFloat viewH = viewW *1.1;
        for (int i=0; i<loops; i++) {
            int y = i/numberOfRows;
            int x = i%numberOfRows;
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(marginLeft *(x+1) + x*viewW, y *(viewH + marginTops), viewW, viewH)];
            imgv.image = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
            [self.messageImageViews addSubview:imgv];
        }
        
    }

}


- (void)buttonClick:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(myDynamiccell:didSelectButtonIndex:)]) {
        NSInteger tag = 0;
        if (self.iphoneIDFBtn) {
            tag = kTAG_BUTTON_IPHONE_IDENTIFY;
        }
        if (self.shareBtn) {
            tag = kTAG_BUTTON_SHARE;
        }
        if (self.readCountBtn) {
            tag = kTAG_BUTTON_READ_COUNT;
        }
        if (self.goodBtn) {
            tag = kTAG_BUTTON_GOOD;
        }
        if (self.commentBtn) {
            tag = kTAG_BUTTON_COMMENT;
        }
        [self.delegate myDynamiccell:self didSelectButtonIndex:tag];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
