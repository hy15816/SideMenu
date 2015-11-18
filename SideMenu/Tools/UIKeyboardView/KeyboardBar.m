//
//  UIKeyboardView.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "KeyboardBar.h"



@implementation KeyboardBar


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:frame];
        keyboardToolbar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:@"前一项" style:UIBarButtonItemStylePlain target:self action:@selector(toolbarButtonClick:)];
        previousBarItem.tag=1;
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:@"后一项"style:UIBarButtonItemStylePlain target:self action:@selector(toolbarButtonClick:)];
        nextBarItem.tag=2;
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(toolbarButtonClick:)];
        doneBarItem.tag=3;
        
        [keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        [self addSubview:keyboardToolbar];
    }
    
    return self;
}

- (void)toolbarButtonClick:(UIBarButtonItem *)item{
    if ([self.delegate respondsToSelector:@selector(keyboardView:didSelectIndex:)]) {
        [self.delegate keyboardView:self didSelectIndex:item.tag];
    }
}


@end

//====================KeyboardBarAction==================

@implementation KeyboardBar (KeyboardBarAction)

- (UIBarButtonItem *)itemForIndex:(NSInteger)itemIndex{
    if (itemIndex < [[keyboardToolbar items] count]) {
        return [[keyboardToolbar items] objectAtIndex:itemIndex];
    }
    return nil;
}

@end
