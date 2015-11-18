//
//  QRCodeView.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/24.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeView : UIView

/**
 *  生成一个黑色背景的二维码，
 *
 *  @param string 生成二维码的数据字符串
 *  @param height 大小
 *
 *  @return UIImage
 */
- (UIImage *)createQRImageWithStr:(NSString *)string height:(CGFloat)height;

/**
 *  生成一个自定义颜色背景的二维码，
 *
 *  @param string 生成二维码的数据字符串
 *  @param height 大小
 *
 *  @return UIImage
 */
- (UIImage *)createQRImageWithStr:(NSString *)string height:(CGFloat)height withRed:(CGFloat )red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

@end
