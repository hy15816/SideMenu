//
//  ShowImagesCollectionVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/12.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "ShowImagesCollectionVC.h"
#import "UIImageView+WebCache.h"

@interface ShowImagesCollectionVC ()
{
    NSMutableArray *_objects;
}
@end

@implementation ShowImagesCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initData];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 27;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height-15)];
    [imagev sd_setImageWithURL:[NSURL URLWithString:[_objects objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-15, cell.frame.size.width, 15)];
    l.textAlignment = NSTextAlignmentCenter;
    l.text = [NSString stringWithFormat:@"image %ld",(long)indexPath.row];
    l.textColor = [UIColor blackColor];
    l.backgroundColor = [UIColor clearColor];
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    [cell.contentView addSubview:l];
    [cell.contentView addSubview:imagev];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.frame.size.width -35)/3+1, 100);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark -- UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //cell.backgroundColor = [UIColor whiteColor];
    NSLog(@"indexPath.section:%ld,indexPath.row:%ld",(long)indexPath.section,(long)indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/



- (void)initData{
    
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CollecttionVCPathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    
    _objects = [NSMutableArray arrayWithObjects:
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png",
                @"http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg",
                @"http://p1.pichost.me/i/40/1639665.png", nil];
    
    [SDWebImageManager.sharedManager.imageDownloader setValue:@"SDWebImage_sidemenu_collection" forHTTPHeaderField:@"SideMenu_collection"];
    SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderFIFOExecutionOrder;//下载将执行队列操作
}

@end
