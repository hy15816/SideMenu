//
//  YIMlrc.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/17.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "YIMlrc.h"

@implementation YIMlrc

- (instancetype)init{
    self = [super init];
    if (self) {
        _timeArray = [NSMutableArray array];
        _wordArray = [NSMutableArray array];
    }
    return self;
}
/**
 *  lrc 路径
 *
 *  @param musicName 歌曲名称
 *  @return string
 */
- (NSString *)getLRCPath:(NSString *)musicName{
    
    return [[NSBundle mainBundle] pathForResource:musicName ofType:@"lrc"];
}

/**
 *  解析歌词
 *
 *  @param musicName 歌曲名称
 */
- (void)parselrc:(NSString *)musicName{
   
    
    NSString *content = [NSString stringWithContentsOfFile:[self getLRCPath:musicName] encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"content--lrcString:\n%@",content);
    if (content.length <=0) {
        NSLog(@"YIMlrc.m,not found music file");
        return;
    }
    NSArray *sepArray = [content componentsSeparatedByString:@"["];
    //NSLog(@"sepArray:%@",sepArray);
    for (int i = 1; i < sepArray.count; i ++) {
        
        //有两个元素，一个是时间，一个是歌词
        NSArray *arr = [sepArray[i] componentsSeparatedByString:@"]"];
        //NSLog(@"arr:%@",arr);
        [_timeArray addObject:arr[0]];
        [_wordArray addObject:[arr[1] length]>0?arr[1]:@" "];

    }
    
    NSLog(@"YIMlrc.m,did found lrc string ");
}

@end
