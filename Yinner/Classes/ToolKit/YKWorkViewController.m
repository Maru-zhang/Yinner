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
    UIButton *_back;
    UIButton *_info;
    AVAudioRecorder *_recorder;
    NSMutableArray *_locationArray;
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
    
    //start添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:50 - KwinW]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:50 - KwinW]];
    
    //back添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_back attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:40 - KwinW]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_back attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:40 - KWinH]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_back attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_back attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    
    //info添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_info attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:40 - KwinW]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_info attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:40 - KWinH]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_info attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_info attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    
    
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
    //添加开始、暂停按钮
    _start = [[UIButton alloc] init];
    _start.backgroundColor = [UIColor redColor];
    [_start setTitle:@"开始" forState:UIControlStateNormal];
    [_start setTitle:@"暂停" forState:UIControlStateSelected];
    [_start.layer setCornerRadius:25];
    [_start addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _start.translatesAutoresizingMaskIntoConstraints = NO;
    _start.adjustsImageWhenHighlighted = NO;

    [self.view addSubview:_start];
    
    //添加返回按钮
    _back = [[UIButton alloc] init];
    _back.backgroundColor = [UIColor redColor];
    [_back setTitle:@"返回" forState:UIControlStateNormal];
    [_back.layer setCornerRadius:20];
    _back.translatesAutoresizingMaskIntoConstraints = NO;
    _back.adjustsImageWhenHighlighted = NO;
    [_back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_back];
    
    //添加信息按钮
    _info = [[UIButton alloc] init];
    _info.backgroundColor = [UIColor redColor];
    [_info setTitle:@"信息" forState:UIControlStateNormal];
    [_info.layer setCornerRadius:20];
    _info.translatesAutoresizingMaskIntoConstraints = NO;
    _info.adjustsImageWhenHighlighted = NO;
    [_info addTarget:self action:@selector(infoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_info];
    
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
            
            //更新本地媒体库
            [self writeToLocationWithFileName:@"test" andPath:url];
            
            
        }];
        
        NSLog(@"最终的地址:%@",myPathDocs);
        
    }];
}

#pragma mark 按钮点击事件
- (void)startButtonClick
{
    _start.selected ? [_start setSelected:NO] : [_start setSelected:YES];
    _videoPlayer.playbackState == MPMoviePlaybackStatePlaying ? [_videoPlayer pause] : [_videoPlayer play];
    
}

- (void)backButtonClick
{
    //退出
    [self exit];
}

- (void)infoButtonClick
{
    
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

#pragma mark 写入本地文件目录
- (void)writeToLocationWithFileName:(NSString *)name andPath:(NSURL *)url
{

}


#pragma mark  退出控制器
- (void)exit
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要放弃当前配音吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [_videoPlayer dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        return ;
    }];
    
    [alert addAction:confirm];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
