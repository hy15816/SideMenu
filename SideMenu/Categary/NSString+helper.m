//
//  NSString+helper.m
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/21.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

#import "NSString+helper.h"

@implementation NSString (helper)


- (BOOL)validateCarNo{

    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}


- (NSString *)OPphoneNo{
    if (self.length==11) {
        
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];;
    }
    return @"我的车牌";
}
@end
