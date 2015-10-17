//
//  GuideController.h
//  TXBoxNew
//
//  Created by Naron on 15/6/24.
//  Copyright (c) 2015年 playtime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuideViewDelegate <NSObject>


@end

@interface GuideView : UIView

@property (assign,nonatomic) id<GuideViewDelegate> delegate;

/**
 *  设置将要显示图片，他们将显示在引导页面上
 *
 *  @param imgsArray 图片数组
 */
-(void) setImages:(NSMutableArray *)imgsArray;

@end
