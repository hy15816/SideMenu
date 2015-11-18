//
//  PlayTableVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/17.
//  Copyright © 2015年 hyIm. All rights reserved.
//  播放音乐界面
//  需要音乐在程序进入后台后同样能够播放，那么在plist文件中，增加Required background modes设置item 0的value为App plays audio or streams audio/video using AirPlay,并在控制器中，添加后台播放音频的设置 AVAudioSession

#import "PlayTableVC.h"
#import "PlayTableCell.h"
#import <AVFoundation/AVFoundation.h>
#import "YIMlrc.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PlayTableVC ()<AVAudioPlayerDelegate,AVAudioSessionDelegate>
{
    AVAudioPlayer *audioPlayer;
    YIMlrc *yimLrc;
    NSInteger currentRow;
    NSTimer *loopTimer;
    UIProgressView *progressView;
    NSTimeInterval totalTime;
    UILabel *totalTimeLabel;
    UILabel *currentTimeLabel;
    NSString *musicNames;//正在播放的歌曲
    NSMutableDictionary *showInfo;
    UIView *bottomView;
    SystemSoundID soundID;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *favourite;
- (IBAction)favouriteClick:(UIBarButtonItem *)sender;

@end

@implementation PlayTableVC
@synthesize song;


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(superViewsSender:) name:UIViewControllerShowDetailTargetDidChangeNotification object:nil];
    
}

//- (void)superViewsSender:(NSNotification *)noti{
//    NSLog(@"PlayTableVC.m,[noyi userInfo] :%@",[noti userInfo]);
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:.5 animations:^{
        //bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0, kDEVICE_HEIGHT-50, kDEVICE_WIDTH, 50)];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    soundID = kSystemSoundID_Vibrate;
    showInfo = [[NSMutableDictionary alloc] init];
    currentRow = 0;
    self.tableView.tableFooterView = [[UIView alloc] init];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDEVICE_WIDTH, kDEVICE_HEIGHT)];
    imgv.image = [UIImage imageNamed:@"Stars"];
    self.tableView.backgroundView = imgv;
    
    musicNames = [kUSERDFS valueForKey:kISPLAYERMUSIC];
    if (![musicNames isEqualToString: song.musicAlais]) {
        musicNames = song.musicAlais;
        [kUSERDFS setValue:musicNames forKey:kISPLAYERMUSIC];
    }
    //解析歌词
    yimLrc = [[YIMlrc alloc] init];
    [yimLrc parselrc:musicNames];
    
    [self addBottomView];
    [self initPlayer];
    
    NSLog(@"musicNames:%@,musicAlais:%@",musicNames,song.musicAlais);
    if (![musicNames isEqualToString: song.musicAlais]) {
        musicNames = song.musicAlais;
        [kUSERDFS setValue:musicNames forKey:kISPLAYERMUSIC];
    }else{
        //暂停或者直接不操作
        //return;
    }

    
}

//初始化定时器并开始
- (void)setupTimer{
    
    [loopTimer invalidate];
    loopTimer = nil;
    
    //定时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    loopTimer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
//关闭定时器
- (void)closeTimer{
    
    [loopTimer invalidate];
    loopTimer = nil;
}
- (void)timeGo{
    if (yimLrc.timeArray.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"未找到歌词"];
        return;
    }
    
    CGFloat currentTime = audioPlayer.currentTime;
    progressView.progress = currentTime/totalTime;
    currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)currentTime/60,(int)currentTime%60];
    
    showInfo[MPNowPlayingInfoPropertyPlaybackRate] = [NSNumber numberWithFloat:1.f];//进度光标的速度
    showInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithDouble:audioPlayer.currentTime];//当前时间
    showInfo[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithDouble:audioPlayer.duration];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:showInfo];
    
    //NSLog(@"%f----------------%02d:%02d",currentTime,(int)currentTime/60,(int)currentTime%60);
    for (int i=(int)currentRow; i<yimLrc.timeArray.count; i++) {
        //NSLog(@"i:%d",i);
        NSArray *arr = [yimLrc.timeArray[i] componentsSeparatedByString:@":"];
        CGFloat compTime = [arr[0] floatValue] *60 + [arr[1] floatValue];
        //NSLog(@"curr:%f,compTime:%f",currentTime,compTime);
        if (currentTime > compTime) {
            currentRow = i;
        }else{
            break;
        }
    }
    //控制歌词混动到当前行
    //NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:currentRow inSection:0];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];//刷新才能改变文字颜色
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    if (currentRow == yimLrc.timeArray.count-1) {
        currentRow = 0;
        [self.tableView reloadData];
    }
}
/**
 *  添加底部播放控制
 */
- (void)addBottomView{
    
    if (!bottomView) {
        bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0, kDEVICE_HEIGHT-50, kDEVICE_WIDTH, 50)];
    }
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    for (int i=0; i<3; i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.backgroundColor = kCOLORRANDOM;
        b.tag = i;
        [b setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        b.frame = CGRectMake(i*kDEVICE_WIDTH/4.f+20*(i+1), 15, kDEVICE_WIDTH/4.f, 30);
        [b addTarget:self action:@selector(bClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:b];
    }
    
    //当前播放时刻Label
    currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50 , 15)];
    currentTimeLabel.font = [UIFont systemFontOfSize:14];
    currentTimeLabel.text = @"00:00";
    [bottomView addSubview:currentTimeLabel];
    
    //进度条
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(60, 5, kDEVICE_WIDTH*.6, 5)];
    progressView.progressViewStyle = UIProgressViewStyleDefault;
    progressView.progress = 0.0f;
    [bottomView addSubview:progressView];
    
    //总时长Label
    totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressView.frame.size.width+10+50+10, 0, kDEVICE_WIDTH -(progressView.frame.size.width+10+50) , 15)];
    totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)totalTime/60,(int)totalTime%60];
    totalTimeLabel.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:totalTimeLabel];
    [[UIApplication sharedApplication].keyWindow addSubview:bottomView];
    
}

- (void)bClick:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:
            //上一曲
            break;
        case 1:
            //暂停/播放
        {
            if (audioPlayer.playing) {
                [audioPlayer pause];
                [self closeTimer];
            }else{
                [audioPlayer play];
                [self setupTimer];
            }
        }
            break;
        case 2:
            //下一曲
            break;
            
        default:
            break;
    }
    
}


/**
 *  初始化音乐播放器
 */
- (void)initPlayer{
    
    NSError *err;
    //后台播放音频设置
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //session.delegate = self;
    [session setActive:YES error:&err];
    [session setCategory:AVAudioSessionCategoryPlayback error:&err];
    //让app支持远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:musicNames ofType:@"mp3"];
    if (!path) {
        [SVProgressHUD showErrorWithStatus:@"未找到该歌曲"];
        NSLog(@"未找到该歌曲！");
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    audioPlayer.pan = 0;//0，1右，-1左声道
    audioPlayer.volume = 1;//音量
    audioPlayer.numberOfLoops = -1;//单曲循环
    
    //速率
    /*
    audioPlayer.enableRate = YES;
    audioPlayer.rate = 1.0;
    */
    
    //总时间
    totalTime = audioPlayer.duration;
    totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)totalTime/60,(int)totalTime%60];
    NSLog(@"总时长：%f",totalTime);
    
    //NSTimeInterval timeInterval =  audioPlayer.currentTime;
    [audioPlayer prepareToPlay];
    //[audioPlayer play];//开始播放
    
    [self showInfoInLockedScreen:song];
}

#pragma mark - 锁屏显歌词
// 在锁屏界面显示歌曲信息(实时换图片MPMediaItemArtwork可以达到实时换歌词的目的)
- (void)showInfoInLockedScreen:(Song *)music
{
    // 健壮性写法:如果存在这个类,才能在锁屏时,显示歌词
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        // 核心:字典
        //NSMutableDictionary *info = [NSMutableDictionary dictionary];
        // 标题(音乐名称)
        showInfo[MPMediaItemPropertyTitle] = music.musicName;
        // 艺术家
        showInfo[MPMediaItemPropertyArtist] = music.musicSinger;
        // 专辑名称
        showInfo[MPMediaItemPropertyAlbumTitle] = music.musicAlbumName;
        showInfo[MPMediaItemPropertyLyrics] = music.musicLrcString;
        // 图片
        showInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:music.musicIcon]];
        // 唯一的API,单例,nowPlayingInfo字典
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = showInfo;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:.5 animations:^{
        bottomView.frame = CGRectMake(0,  kDEVICE_HEIGHT, kDEVICE_WIDTH, 50);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextMmusic{
    
    NSLog(@"next music");
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return yimLrc.wordArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayTableCellID" forIndexPath:indexPath];
    cell.lrcLabel.text = [yimLrc.wordArray objectAtIndex:indexPath.row];
    if (indexPath.row == currentRow) {
        cell.lrcLabel.textColor = [UIColor greenColor];
    }else{
        cell.lrcLabel.textColor = [UIColor whiteColor];
    }
    // Configure the cell...
    
    return cell;
}


#pragma mark - AVAudioPlayerDelegate
//播放完毕，
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self nextMmusic];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    if (error) {
        NSLog(@"err:%@",error.localizedDescription);
    }
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"开始中断");
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    NSLog(@"结束中断");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)favouriteClick:(UIBarButtonItem *)sender {
    
    //[self playSoundEffect:@"default" type:@"caf"];
    [self playingSystemSoundEffectWith:@"Ladder" ofType:@"caf"];
}
#pragma mark - ========================华丽的分割线===========================
#pragma mark - 播放短音效，系统声音，等(<AudioToolbox/AudioToolbox.h>)
/**
 *  播放音效文件
 *
 *  @param name 音频文件名称
 */
-(void)playSoundEffect:(NSString *)name type:(NSString *)type{
    
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:type];
    if (!audioFile) {
        NSLog(@"未找到指定音效文件");
        return;
    }
    
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL URLWithString:audioFile]), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    //AudioServicesPlaySystemSound(soundID);//播放音效
    AudioServicesPlayAlertSound(soundID);//播放音效并震动
    
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    
    NSLog(@"播放完成...");
}

/**
 *  播放系统音效
 *
 *  @param resourceName 音效名字
 *  @param type         type
 */
- (void)playingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type {
    //http://my.oschina.net/are1OfBlog/blog/476751 系统音效列表
    NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
    if (path) {
        SystemSoundID theSoundID;
        OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
        if (error == kAudioServicesNoError) {
            soundID = theSoundID;
        }else {
            NSLog(@"Failed to create sound ");
        }
    }
    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
        NSLog(@"player end");
    });
}

/**
 *  播放特定的音频文件(需提供音频文件)
 *
 *  @param filename 文件名(需手动添加到工程中)
 */
-(void)playingSoundEffectWith:(NSString *)filename {
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    if (fileURL != nil) {
        SystemSoundID theSoundID;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
        if (error == kAudioServicesNoError){
            soundID = theSoundID;
        }else {
            NSLog(@"Failed to create sound ");
        }
    }
    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
        NSLog(@"player end");
    });

}

@end
