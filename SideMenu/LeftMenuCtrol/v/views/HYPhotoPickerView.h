//
//  HYPhotoPickerManager.h
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/11/5.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPhotoPickerView : UIView


+ (HYPhotoPickerView *)shard;

/**
 *  选择图片或者拍照完成选择使用图片后调用
 *
 *  @param image 选择的图片
 */
typedef void (^PhotoPickerCompelitionBlock)(UIImage *image);

/**
 *  用户点击取消
 */
typedef void (^PhotoPickerCancelBlock)();

/**
 *  弹出一个选项卡，
 *
 *  @param formController 当前controller
 *  @param completion     选中图片回调
 *  @param cancelBlock    用户取消
 */
- (void)showActionInViewController:(UIViewController *)formController completion:(PhotoPickerCompelitionBlock)completion cancelBlock:(PhotoPickerCancelBlock)cancelBlock;

@end
