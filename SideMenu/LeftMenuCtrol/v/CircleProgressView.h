//
//  CircleProgressView.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/12.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

@property (nonatomic) UIColor *backColor;
@property (nonatomic) UIColor *progressColor;
@property (nonatomic) NSURL *audioURL;
/**
 *  圆环宽度
 */
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) NSTimeInterval duration;

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth;
@end
