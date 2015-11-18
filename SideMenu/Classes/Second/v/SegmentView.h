//
//  SegmentView.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/30.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#define kTAG_ITEM_BUTTON 20151030

#import <UIKit/UIKit.h>
@class SegmentView;
@protocol SegmentViewDelegate <NSObject>
@optional
/**
 *  选中了哪个item，
 *
 *  @param segmentView SegmentView
 *  @param index       item.index
 */
- (void)segmentView:(SegmentView *)segmentView didSelectIndex:(NSInteger)index;

@end

@interface SegmentView : UIView
/**
 *  移动的颜色块的颜色
 */
@property (strong,nonatomic) UIColor *moveViewColor;



/**
 *  创建一个类似UISegmentCtorller的view,自定义item个数、font,
 *
 *  @param frame    frame, 若items的长度>设定的frame.size.width,则会自动加宽，为了显示完全title
 *  @param delegate SegmentViewDelegate
 *  @param items    NSArray
 *  @param font     item's title font df [UIFont systemFontOfSize:14.f]
 *
 *  @return SegmentView
 */
- (id)initWithFrame:(CGRect)frame delegate:(id<SegmentViewDelegate>)delegate items:(NSArray *)items font:(UIFont *)font;

@end
