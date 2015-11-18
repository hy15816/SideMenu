//
//  TestCellTableVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/17.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "TestCellTableVC.h"
#import "TestTableCell.h"
#import "Song.h"
#import "PlayTableVC.h"

@interface TestCellTableVC ()
{
    NSMutableArray *_songArray;
}

- (IBAction)button1Click:(UIButton *)sender;
- (IBAction)button2Click:(UIButton *)sender;
- (IBAction)button3Click:(UIButton *)sender;

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation TestCellTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndexPath = nil;
    self.tableView.tableFooterView = [[UIView alloc] init];
    _songArray = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++) {
        Song *song = [[Song alloc] init];
        song.musicName = @"春暖花开";
        song.musicSinger = @"那英";
        song.musicIcon = @"Stars";
        song.musicAlbumName = @"《2013蛇年春晚》";
        song.musicLrcString = @"12324e3dsd";
        song.musicAlais = @"cnhk";
        if (i==3) {
            song.musicName = @"你好";
            song.musicAlais = @"nihao";
        }
        [_songArray addObject:song];
    }
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

    return _songArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTableCellID" forIndexPath:indexPath];
    cell.inagesView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu",indexPath.row+5]];
    Song *music = _songArray[indexPath.row];
    cell.nameLabel.text = music.musicName;
    
    [cell.button0 addTarget:self action:@selector(button0Click:event:) forControlEvents:UIControlEventTouchUpInside];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([indexPath isEqual:self.selectedIndexPath]) {
        
        return 50 + 50;
    }
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayTableVC *playVC = [kMainStoryboard instantiateViewControllerWithIdentifier:@"PlayTableVCIDF"];
    playVC.song = _songArray[indexPath.row];
    [self.navigationController showViewController:playVC sender:@"qwe"];
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

- (IBAction)button1Click:(UIButton *)sender {
    NSLog(@"button1Click");
}
- (IBAction)button2Click:(UIButton *)sender{
    NSLog(@"button2Click");
}
- (IBAction)button3Click:(UIButton *)sender{
    NSLog(@"button3Click");
}

//
- (void)button0Click:(UIButton *)sender event:(id)event{
    
    //通过point获取indexPath
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath= [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    //NSLog(@"-----------------%lu",indexPath.row);
    if (indexPath!= nil) {
        
        if ([indexPath isEqual:self.selectedIndexPath]) {
            self.selectedIndexPath = nil;
            
        }else {
            self.selectedIndexPath = indexPath;
        }
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];

    }
    
}
@end
