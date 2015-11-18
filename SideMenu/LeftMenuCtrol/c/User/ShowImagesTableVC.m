//
//  ShowImagesTableVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/11.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "ShowImagesTableVC.h"
#import "UIImageView+WebCache.h"
#import "DetailImageVC.h"

@interface ShowImagesTableVC ()
{
    NSMutableArray *_objects;
    
}
- (IBAction)clearButtonClick:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@end

@implementation ShowImagesTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
        1.若有默认图片，先显示默认图片
        2.根据URL处理图片，从缓存中查找是否已经下载，
        3.先从内存中找，如果有，cache回调到manager，再由UIImageView+WebCache等回调展示UI
        4.内存中没有，尝试在磁盘中读取图片文件，将图片添加到内存中，回调展示图片
        5.若所有缓存中都找不到该URL图片，则需要下载，
        6.connectionDidFinishLoading: 数据下载完成后交给 SDWebImageDecoder 做图片解码处理。 图片解码处理在一个 NSOperationQueue 完成，不会拖慢主线程 UI。如果有需要对下载的图片进行二次处理，最好也在这里完成，效率会好很多。
        7.下载完成后回调在UI显示图片，
        8.缓存图片，将图片保存到 SDImageCache 中，内存缓存和硬盘缓存同时保存。写文件到硬盘也在以单独 NSInvocationOperation 完成，避免拖慢主线程。
     */
    
    
    //Add a custom read-only cache path
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PathImages"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    
    [SDWebImageManager sharedManager].imageDownloader.username = @"httpwatch";
    [SDWebImageManager sharedManager].imageDownloader.password = @"httpwatch01";
    
    _objects = [NSMutableArray arrayWithObjects:@"http://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx?0.35786508303135633",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",nil];
    
    [SDWebImageManager.sharedManager.imageDownloader setValue:@"SDWebImage_sidemenu" forHTTPHeaderField:@"SideMenu"];
    SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderFIFOExecutionOrder;//下载将执行队列操作
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getCacheInfo];
    
}

/**
 *  获取缓存信息
 */
- (void)getCacheInfo{
    
    self.title = [NSString stringWithFormat:@"图片:%lu,%.2fM",(unsigned long)[SDWebImageManager.sharedManager.imageCache getDiskCount],(unsigned long)[SDWebImageManager.sharedManager.imageCache getSize]/1024.f/1000.f];
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

    return _objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowImagesCellID" forIndexPath:indexPath];
    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:_objects[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:indexPath.row == 0 ? SDWebImageCacheMemoryOnly : 0];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://p1.pichost.me/i/40/1639665.png"] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached ];
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Image #%ld", (long)indexPath.row];
    
    return cell;
}

/**
 *  清除缓存
 */
- (void)clearCaches{
    
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailImageVC *_detailVC = [kLeftStoryboard instantiateViewControllerWithIdentifier:@"DetailImageVCIDF"];
    NSString *largeImageURL = [@"http://p1.pichost.me/i/40/1639665.png" stringByReplacingOccurrencesOfString:@"small" withString:@"source"];
    _detailVC.imageURL = [NSURL URLWithString:largeImageURL];
    [self.navigationController pushViewController:_detailVC animated:YES];
}

- (IBAction)clearButtonClick:(UIBarButtonItem *)sender {
    [self clearCaches];
    [self getCacheInfo];
}
@end
