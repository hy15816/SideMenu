//
//  MusicListCell.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/12.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "MusicListCell.h"

@implementation MusicListCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype) cellWithTableView:(UITableView*)tableView{
    // 1. 可重用标示符
    static NSString *ID = @"MusicListCellID";
    // 2. tableView查询可重用Cell
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有可重用cell
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MusicListCell" owner:nil options:nil]lastObject];
    }
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
