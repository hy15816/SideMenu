//
//  PreViewViewController.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/13.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface PreViewViewController : UIViewController

@property (strong,nonatomic) void(^previewFinishBlock)(NSMutableArray *array);

@property (strong,nonatomic) NSMutableArray *selectedArray;

@end
