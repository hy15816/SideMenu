//
//  PreviewCollectionVC.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/14.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewCollectionVC : UIViewController

@property (strong,nonatomic) void(^previewFinishBlock)(NSMutableArray *array);

@property (strong,nonatomic) NSMutableArray *selectedArray;

@end
