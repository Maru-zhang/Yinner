//
//  YKWorkViewController.m
//  Yinner
//
//  Created by Maru on 15/5/27.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKWorkViewController.h"

#define KWinH [UIScreen mainScreen].bounds.size.height
#define KwinW [UIScreen mainScreen].bounds.size.width

@interface YKWorkViewController ()
{
    UIButton *_start;
    AVAudioRecorder *_recorder;
}
@end

@implementation YKWorkViewController

singleton_implementation(YKWorkViewController)

#pragma mark - 工场方法
+ (YKWorkViewController *)WorkViewControllerWithURL:(NSURL *)url
{
    YKWorkViewController *controller = [YKWorkViewController sharedYKWorkViewController];
    
    controller.videoURL = url;

    [controller playVideoWithURL:url];
    
    return controller;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.298 alpha:1.000];
    
    //添加返回手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(exit)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    //隐藏状态栏
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    [self setupView];
}

#pragma mark - autolayout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:50 - self.view.frame.size.width]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:50 - self.view.frame.size.width]];
    
}

#pragma mark - 重写父类方法
#pragma mark 隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - 初始化视图
- (void)setupView
{
    _start = [[UIButton alloc] init];
    _start.backgroundColor = [UIColor redColor];
    [_start setTitle:@"start" forState:UIControlStateNormal];
    [_start.layer setCornerRadius:25];
    [_start addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _start.translatesAutoresizingMaskIntoConstraints = NO;
    

    [self.view addSubview:_start];
}



#pragma mark - private method
- (void)playVideoWithURL:(NSURL *)url
{
    if (!_videoPlayer) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _videoPlayer = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoPlayer setDimissCompleteBlock:^{
            weakSelf.videoPlayer = nil;
        }];
        
        [self.videoPlayer showInWindow];
    }
    self.videoPlayer.contentURL = url;
    
    //添加消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDurationChange) name:MPMovieDurationAvailableNotification object:nil];
    
}

#pragma mark mrege video&audio
- (void)mregeWithVideo:(NSURL *)videoURL andAudio:(NSURL *)audioURL
{
//    AVURLAsset *testAsset = [[AVURLAsset alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"example" withExtension:@"mov"] options:nil];
    
//    NSURL *videourl = [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"mov"];
//    NSURL *audiourl = [NSURL URLWithString:@"/Users/maru/Library/Developer/CoreSimulator/Devices/97C2E3E5-8C1A-46CC-B060-516A01742216/data/Containers/Data/Application/DEFA2C68-BDDC-441E-8078-D9D7EE390CF5/Library/Caches/test.wav"];
    
//    NSURL *videoTest = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mov"];
//    NSURL *audiotest = [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"wav"];
//    
//    NSLog(@"%@",videoTest.absoluteString);
//    NSLog(@"%@",audiotest.absoluteString);
    
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioURL options:nil];
    
    //合成器
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    //创建音轨
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //在音轨中插入资源
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //创建保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"example.mov"];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    //创建输出对象
    AVAssetExportSession *export = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    export.outputURL = url;
    export.outputFileType = AVFileTypeQuickTimeMovie;
    export.shouldOptimizeForNetworkUse = YES;
    
    [export exportAsynchronouslyWithCompletionHandler:^{
        //友情提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜您，配音成功！" preferredStyle:UIAlertControllerStyleAlert];
        
        //添加按钮
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"待会再看" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:confirm];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }];
}

- (void)startButtonClick
{
    _videoPlayer.playbackState == MPMoviePlaybackStatePlaying ? [_videoPlayer pause] : [_videoPlayer play];
    
}

- (void)onDurationChange
{
    [self startAudioRecordWithName:@"test" andDuration:_videoPlayer.duration];
}

#pragma mark audio record
- (void)startAudioRecordWithName:(NSString *)name andDuration:(NSTimeInterval)duration
{
    //录音参数设置
    NSMutableDictionary *recorderSetting = [NSMutableDictionary dictionary];
    
    //设置保存格式
    [recorderSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置采样频率
    [recorderSetting setValue:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
    //设置通道数
    [recorderSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //设置采样位数
    [recorderSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //设置录音质量
    [recorderSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    //获取存储路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.wav",cachePath,name]];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recorderSetting error:nil];
    
    _recorder.delegate = self;
    
    [_recorder recordForDuration:duration];
    
    [_recorder record];
    
    _audioURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.wav",cachePath,name]];
    
    NSLog(@"%@",cachePath);
    
}


#pragma mark  退出控制器
- (void)exit
{
    [_videoPlayer dismiss];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - audioRecode delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"完成录音");
    NSLog(@"videoURL:%@",_videoURL);
    NSLog(@"audioURL:%@",_audioURL);
    
    //开始合成
    [self mregeWithVideo:_videoURL andAudio:_audioURL];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"出错");
}

@end
