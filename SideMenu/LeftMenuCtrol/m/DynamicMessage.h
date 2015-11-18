//
//  DynamicMessage.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicMessage : NSObject

/**
 *  头像data
 */
@property (strong,nonatomic) NSData *userImageData;

/**
 *  用户昵称
 */
@property (strong,nonatomic) NSString *userName;

/**
 *  显示背景音乐名称
 */
@property (strong,nonatomic) NSString *bgMusicName;

/**
 *  发表时间
 */
@property (strong,nonatomic) NSString *sendDate;

/**
 *  某钻的图片名称
 */
@property (strong,nonatomic) NSString *diamondImageName;

/**
 *  空间等级图片名称
 */
@property (strong,nonatomic) NSString *zoneLeverImageName;

/**
 *  发表的文字信息
 */
@property (strong,nonatomic) NSString *messageContent;

/**
 *  发表的图片
 */
@property (strong,nonatomic) NSMutableArray *imagesArray;

/**
 *  浏览次数
 */
@property (strong,nonatomic) NSString *readCount;

/**
 *  赞的次数
 */
@property (strong,nonatomic) NSString *goodCount;


@end
