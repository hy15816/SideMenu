//
//  MyDynamicTableVc.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//  我的动态

#import "MyDynamicTableVc.h"
#import "MyDynamicCell.h"
#import "DynamicMessage.h"

@interface MyDynamicTableVc ()<MyDynamicCellDelegate>
{
    NSMutableArray *messageArray;
}
@end

@implementation MyDynamicTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    messageArray = [[NSMutableArray alloc] init];
    DynamicMessage *message = [[DynamicMessage alloc] init];
    message.userName = @"战三";
    message.bgMusicName = @"take me to your heart";
    message.sendDate = [GlobalTool getCurrDateWithFormat:@"yyyy-M-d HH:mm"];
    message.diamondImageName = @"diamond_image_lv_10";
    message.zoneLeverImageName = @"zone_image_lv_12";
    message.messageContent = @"说说内容，说说内容，说说内容，说说内容，说说内容，说说内容，说说内容，说说内容，说说内容，说说内容，";
    message.readCount = @"999次";
    message.goodCount = @"100次";
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"user_icon", nil];
    message.imagesArray = arr;
    
    [messageArray addObject:message];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDynamicCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    DynamicMessage *message = messageArray[indexPath.row];
    cell.userNameLabel.text = message.userName;
    cell.messageContentLabel.text = message.messageContent;
    cell.sendDateLabel.text = message.sendDate;
    cell.bgmusicLabel.text = message.bgMusicName;
    [cell.readCountBtn setTitle:message.readCount forState:UIControlStateNormal];
    [cell.goodBtn setTitle:message.goodCount forState:UIControlStateNormal];
    cell.imagesArray = message.imagesArray;
    
    return cell;
}

#pragma mark - MyDynamicCellDelegate

- (void)myDynamiccell:(MyDynamicCell *)dynamiccell didSelectButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex:%ld",(long)buttonIndex);
}

- (void)myDynamiccell:(MyDynamicCell *)dynamiccell tapViewsTag:(NSInteger)viewTag{
    NSLog(@"tag:%ld",(long)viewTag);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
