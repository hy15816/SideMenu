//
//  NSString+helper.h
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/21.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (helper)

//判断车牌是否合法
- (BOOL)validateCarNo;

/**
 *  处理手机号码，如138****0000
 *
 *  @return <#return value description#>
 */
- (NSString *)OPphoneNo;
@end
