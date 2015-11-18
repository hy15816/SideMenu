//
//  Song.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/18.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

/**
 *  艺术家
 */
@property (strong,nonatomic) NSString *musicSinger;
/**
 *  标题/音乐名称
 */
@property (strong,nonatomic) NSString *musicName;

/**
 *  图片
 */
@property (strong,nonatomic) NSString *musicIcon;

/**
 *  专辑名称
 */
@property (strong,nonatomic) NSString *musicAlbumName;
/**
 *  歌词
 */
@property (strong,nonatomic) NSString *musicLrcString;

/**
 *  歌曲别名
 */
@property (strong,nonatomic) NSString *musicAlais;

@end
