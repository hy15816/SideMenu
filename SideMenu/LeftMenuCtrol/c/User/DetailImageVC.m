//
//  DetailImageVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/11.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "DetailImageVC.h"
#import "UIImageView+WebCache.h"
#import "RoundProgress.h"
#import "CircleProgress.h"

@interface DetailImageVC ()
{
    RoundProgress *progress;
}
@property (strong, nonatomic) IBOutlet UIImageView *dImageView;

@end

@implementation DetailImageVC
@synthesize imageURL = _imageURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    progress = [[RoundProgress alloc]initWithFrame:CGRectMake((self.dImageView.frame.size.width-60)/2, (self.dImageView.frame.size.height-60)/2, 60, 60)];
    progress.arcFinishColor = kCOLORVALUE(0x75AB33, 1);
    progress.arcUnfinishColor = kCOLORVALUE(0x0D6FAE, 1);
    progress.arcBackColor = kCOLORVALUE(0xEAEAEA, 1);
    progress.percent = 0.0;

    [self configureView];
    
    /*
    CircleProgress *circle = [[CircleProgress alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    circle.center = self.dImageView.center;
    circle.progress = .5;
    [self.dImageView addSubview:circle];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        circle.progress = 1;
    });
    */
}

- (void)setImageURL:(NSURL *)imageURL{
    if (_imageURL != imageURL) {
        _imageURL = imageURL;
        [self configureView];
    }
}

- (void)configureView
{
    if (self.imageURL) {
        //SDWebImageContinueInBackground 后台下载，SDWebImageProgressiveDownload 渐进下载，SDWebImageDelayPlaceholder
        [self.dImageView sd_setImageWithURL:self.imageURL placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
          dispatch_async(dispatch_get_main_queue(), ^{
              
              [self.dImageView addSubview:progress];
              progress.percent = receivedSize/(expectedSize *1.f);
              NSLog(@"fffffff:%f",receivedSize/(expectedSize *1.f));
              if (receivedSize/expectedSize ==1) {
                  if (progress) {
                      [progress removeFromSuperview];
                  }
              }
               
              
              
          });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            NSLog(@"completed");
        }];
        
    }else{
        
    }
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

@end
