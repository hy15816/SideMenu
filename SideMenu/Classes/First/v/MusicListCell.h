//
//  MusicListCell.h
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/12.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *songerIcon;        //头像
@property (strong, nonatomic) IBOutlet UILabel *songerAndMusic;     //人名-歌名

/**
 *  快速创建cell
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype) cellWithTableView:(UITableView*)tableView;


@end
