//
//  ScanVC.h
//  HYTabBar
//
//  Created by AEF-RD-1 on 15/9/14.
//  Copyright (c) 2015年 com.hyIm. All rights reserved.
//

#import "ProjBaseSecVC.h"

@interface ScanVC : ProjBaseSecVC

@property (copy, nonatomic) void (^scanFinishedBlock) (NSString *result);

@end
