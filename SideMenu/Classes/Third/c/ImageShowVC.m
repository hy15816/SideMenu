//
//  ImageShowVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/13.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "ImageShowVC.h"

@interface ImageShowVC ()<NSURLSessionDownloadDelegate,NSURLConnectionDelegate>
{
    NSURLSession *_session;
    NSURLRequest *_request;
    NSURLSessionDownloadTask *_downloadTask;
    NSData *_partialData;
    NSMutableData *_mutData;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imageViews;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

- (IBAction)startClick:(UIButton *)sender;
- (IBAction)pauseClick:(UIButton *)sender;
- (IBAction)resumeClick:(UIButton *)sender;
@end

@implementation ImageShowVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化
    self.progressView.progress = .0;
    NSMutableData *da = [[NSMutableData alloc] initWithContentsOfFile:kPlistPath(@"myImage")];
    UIImage *image = [UIImage imageWithData:da];
    self.imageViews.image = image;
    if (!image) {
        [self requestWithURLString:@"http://p1.pichost.me/i/40/1639665.png" delegate:self timeout:60];
    }
    //================22222==========@""//http://pica.nipic.com/2007-12-12/20071212235955316_2.jpg
    

}

- (void)requestWithURLString:(NSString *)urlString delegate:(id<NSURLConnectionDelegate>)delegate timeout:(NSInteger)time{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    [req setURL:url];
    [req setHTTPMethod:@"GET"];
    [req setTimeoutInterval:time];
    _mutData = [[NSMutableData alloc] init];
    [NSURLConnection connectionWithRequest:req delegate:delegate];
    
}

#pragma mark - NSURLConnection delegate
//数据加载过程中调用,获取数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_mutData appendData:data];
    UIImage *image = [UIImage imageWithData:_mutData];
    self.imageViews.image = image;
    //NSLog(@"mutData:%@",_mutData);
}

//数据加载完成后调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //UIImage *image = [UIImage imageWithData:_mutData];
    //self.imageViews.image = image;
    //把数据保存到本地
    if(![[NSFileManager defaultManager] fileExistsAtPath:kPlistPath(@"myImage")])
    {
        NSArray *arr = [[NSArray alloc] init];
        [arr writeToFile:kPlistPath(@"myImage") atomically:YES];
    }
    [_mutData writeToFile:kPlistPath(@"myImage") atomically:YES];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"reu err :%@",error.localizedDescription);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //父类方法，
    //[self showProViewSec:ShowProgressTypeDefault];
}

- (NSURLRequest *)request{
    //创建请求
    NSURL *url = [NSURL URLWithString:@"http://p1.pichost.me/i/40/1639665.png"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

- (NSURLSession *)session
{
    //创建NSURLSession
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession  *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    return session;
}

//创建文件本地保存目录
-(NSURL *)createDirectoryForDownloadItemFromURL:(NSURL *)location
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = urls[0];
    return [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
}
//把文件拷贝到指定路径
-(BOOL) copyTempFileAtURL:(NSURL *)location toDestination:(NSURL *)destination
{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:destination error:NULL];
    [fileManager copyItemAtURL:location toURL:destination error:&error];
    if (error == nil) {
        return true;
    }else{
        NSLog(@"%@",error);
        return false;
    }
}
#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    //下载成功后，文件是保存在一个临时目录的，需要开发者自己考到放置该文件的目录
    NSLog(@"Download success for URL: %@",location.description);
    NSURL *destination = [self createDirectoryForDownloadItemFromURL:location];
    BOOL success = [self copyTempFileAtURL:location toDestination:destination];
    
    if(success){
        //文件保存成功后，使用GCD调用主线程把图片文件显示在UIImageView中
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destination path]];
            _imageViews.image = image;
            _imageViews.contentMode = UIViewContentModeScaleAspectFit;
            _imageViews.hidden = NO;
        });
    }else{
        NSLog(@"Meet error when copy file");
    }
    _downloadTask = nil;
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"bytesWritten(当次下载量): %lld,,,totalBytesWritten(已下载总数): %lld,,,,,totalBytesExpectedToWrite(总数): %lld B/%lld KB/ %.2f M",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite,totalBytesExpectedToWrite/1000,totalBytesExpectedToWrite/1000/1024.f);
    
    //刷新进度条的delegate方法，同样的，获取数据，调用主线程刷新UI
    double currentProgress = totalBytesWritten/(double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = currentProgress;
        _progressView.hidden = NO;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
    NSLog(@"fileOffset:%lld",fileOffset);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Actions
- (IBAction)startClick:(UIButton *)sender {
    
    //用NSURLSession和NSURLRequest创建网络任务
    _downloadTask = [[self session] downloadTaskWithRequest:[self request]];
    [_downloadTask resume];
    //[self getURLImages];
    
}

- (IBAction)pauseClick:(UIButton *)sender {
    
    NSLog(@"Pause download task");
    if (_downloadTask) {
        //取消下载任务，把已下载数据存起来
        [_downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            //self.partialData = resumeData;
            _downloadTask = nil;
        }];
    }
}

- (IBAction)resumeClick:(UIButton *)sender {
    
    NSLog(@"resume download task");
    if (!_downloadTask) {
        //判断是否又已下载数据，有的话就断点续传，没有就完全重新下载
        if (_partialData) {
            _downloadTask = [_session downloadTaskWithResumeData:_partialData];
        }else{
            _downloadTask = [_session downloadTaskWithRequest:_request];
        }
    }
    [_downloadTask resume];
}
@end
