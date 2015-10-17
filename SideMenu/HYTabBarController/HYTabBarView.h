//
//  HYTabBarView.h
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/10.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTabBarView;
@protocol HYTabBarViewDelegate  <NSObject>
@optional
/**
 *  创建一个选项卡，barItem
 *
 *  @param barView HYTabBarView
 *  @param from    item.tag
 *  @param toItem  next item.tag
 */
-(void)tabBarView:(HYTabBarView *)barView fromItem:(NSInteger )from toItem:(NSInteger)toItem;

@end

@interface HYTabBarView : UIView

/**
 *  添加一个barItem
 */
-(void)addItemIcon:(NSString *)norma select:(NSString *)selectIcon title:(NSString *)title selectTitlt:(NSString *)selectTitle;

@property (assign,nonatomic) id<HYTabBarViewDelegate> delegate;

@end
