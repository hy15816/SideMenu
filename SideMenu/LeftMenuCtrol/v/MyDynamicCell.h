//
//  MyDynamicCell.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyDynamicCell;
@protocol MyDynamicCellDelegate <NSObject>
@optional
/**
 *  点击了哪个button
 *
 *  @param dynamiccell self
 *  @param buttonIndex button.tag
 */
- (void)myDynamiccell:(MyDynamicCell*)dynamiccell didSelectButtonIndex:(NSInteger)buttonIndex;

/**
 *  tap 了哪个view
 *
 *  @param dynamiccell self
 *  @param view        view（UILabel,UIImageView）的tag
 */
- (void)myDynamiccell:(MyDynamicCell*)dynamiccell tapViewsTag:(NSInteger)viewTag;



@end

@interface MyDynamicCell : UITableViewCell


@property (assign,nonatomic) id<MyDynamicCellDelegate> delegate;

/**
 *  用户头像
 */
@property (strong, nonatomic) IBOutlet UIImageView *userIconImageView;

/**
 *  用户昵称
 */
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

/**
 *  发表说说的时间
 */
@property (strong, nonatomic) IBOutlet UILabel *sendDateLabel;
/**
 *  背景音乐名称
 */
@property (strong, nonatomic) IBOutlet UILabel *bgmusicLabel;

/**
 *  黄钻图标
 */
@property (strong, nonatomic) IBOutlet UIImageView *isYelloDiamondImgv;

/**
 *  空间等级图标
 */
@property (strong, nonatomic) IBOutlet UIImageView *zoneLevelImgv;

/**
 *  说说的文字信息
 */
@property (strong, nonatomic) IBOutlet UILabel *messageContentLabel;

/**
 *  说说的图片
 */
@property (strong, nonatomic) IBOutlet UIView *messageImageViews;
/**
 *  图片数组
 */
@property (strong,nonatomic) NSMutableArray *imagesArray;

/**
 *  是哪种手机
 */
@property (strong, nonatomic) IBOutlet UIButton *iphoneIDFBtn;
/**
 *  分享
 */
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;

/**
 *  浏览？次
 */
@property (strong, nonatomic) IBOutlet UIButton *readCountBtn;

/**
 *  赞
 */
@property (strong, nonatomic) IBOutlet UIButton *goodBtn;
/**
 *  评论button
 */
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

/**
 *  有哪些人赞了，显示在这
 */
@property (strong, nonatomic) IBOutlet UILabel *goodPeoplesLabel;
/**
 *  赞，图片
 */
@property (strong, nonatomic) IBOutlet UIButton *goodImgsBtn;

/**
 *  我也说一句 Field
 */
@property (strong, nonatomic) IBOutlet UITextField *sayTextField;

@end
