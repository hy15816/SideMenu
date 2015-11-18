//
//  YIMlrc.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/17.
//  Copyright © 2015年 hyIm. All rights reserved.
//  歌词解析

#import <Foundation/Foundation.h>

@interface YIMlrc : NSObject
/**
 *  时间
 */
@property (strong,nonatomic) NSMutableArray *timeArray;
/**
 *  歌词
 */
@property (strong,nonatomic) NSMutableArray *wordArray;

- (void)parselrc:(NSString *)musicName;

@end
