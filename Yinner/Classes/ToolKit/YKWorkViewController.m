//
//  YKWorkViewController.m
//  Yinner
//
//  Created by Maru on 15/5/27.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKWorkViewController.h"
#import "YKSubtitleView.h"
#import "YKBrowseViewController.h"
#import "YKLocationViewController.h"
#import "NSURL+File.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "YKSubtitleIndicator.h"
#import "YKDownloadOperator.h"

#define kSUBTITLE_H 140.0

typedef void(^mergeMediaComplete)(YKLocationMediaModel *model);

@interface YKWorkViewController ()
{
    UIButton *_start;
    UIButton *_back;
    UIButton *_info;
    YKSubtitleView *_subTitle;
    NSMutableArray *_locationArray;
    NSMutableDictionary *_subTitleArray;
    NSMutableArray *_subTitleTimeArray;
    int _currentTime;
}
/** 视频播放器 */
@property (nonatomic,strong) AVPlayer *videoPlayer;
/** 视频播放图层 */
@property (nonatomic,strong) AVPlayerLayer *videoLayer;
/** 录音器 */
@property (nonatomic,strong)  AVAudioRecorder *recorder;
/** 背景音乐播放器 */
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
/** 时间器 */
@property (nonatomic,weak) NSTimer *timeManager;
@end

@implementation YKWorkViewController

#pragma mark - 构造方法
- (instancetype)initWithModel:(YKMatterModel *)model {
    if (self = [super init]) {
        _matter = model;
    }
    return self;
}


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化设置
    [self setupSetting];
    //初始化视图
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 输出路径
    // 检查是否已经缓存完毕
    if ([[NSFileManager defaultManager] fileExistsAtPath:[ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:[self.matter.video_url lastPathComponent]]]) {
        
        [self loadResource];
        
    }else {
        
        [SVProgressHUD showWithStatus:@"正在下载素材中..."];
        
        YKDownloadOperator *operator = [[YKDownloadOperator alloc] init];
        
        [operator downloadWithMatter:self.matter successHandler:^(id responseObject) {
            
            [SVProgressHUD dismiss];
            
            [self loadResource];
        } failureHandler:^(NSError *error) {
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showErrorWithStatus:@"下载失败!"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timeManager invalidate];
    
    [self.videoPlayer.currentItem cancelPendingSeeks];
    
    [self.videoPlayer.currentItem.asset cancelLoading];
}

- (void)dealloc {
    debugLog(@"销毁了");
}

#pragma mark - autolayout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //start添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:80 - KwinW]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_start attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:80 - KwinW]];
    
    //back添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_back attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:40 - KwinW]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_back attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:40 - KwinH]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_back attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_back attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    
    //info添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_info attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:40 - KwinW]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_info attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:40 - KwinH]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_info attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_info attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    
    //字幕添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_subTitle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_subTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:(KwinW / 16) * 9]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_subTitle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-kSUBTITLE_H]];
    
}

#pragma mark - 重写父类方法
#pragma mark 隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - 初始化
- (void)setupView
{
    // 添加播放图层
    [self.view.layer addSublayer:self.videoLayer];
    
    // 添加开始、暂停按钮
    _start = [[UIButton alloc] init];
    _start.backgroundColor = [UIColor clearColor];
    [_start setImage:[UIImage imageNamed:@"record_start"] forState:UIControlStateNormal];
    [_start setImage:[UIImage imageNamed:@"record_pause"] forState:UIControlStateSelected];
    [_start.layer setCornerRadius:25];
    [_start addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _start.translatesAutoresizingMaskIntoConstraints = NO;
    _start.adjustsImageWhenHighlighted = NO;
    _start.hidden = YES;

    [self.view addSubview:_start];
    
    //添加返回按钮
    _back = [[UIButton alloc] init];
    _back.backgroundColor = [UIColor clearColor];
    [_back setImage:[UIImage imageNamed:@"record_back"] forState:UIControlStateNormal];
    [_back.layer setCornerRadius:20];
    _back.translatesAutoresizingMaskIntoConstraints = NO;
    _back.adjustsImageWhenHighlighted = NO;
    [_back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _back.hidden = YES;
    
    [self.view addSubview:_back];
    
    //添加信息按钮
    _info = [[UIButton alloc] init];
    _info.backgroundColor = [UIColor clearColor];
    [_info setImage:[UIImage imageNamed:@"record_info"] forState:UIControlStateNormal];
    [_info.layer setCornerRadius:20];
    _info.translatesAutoresizingMaskIntoConstraints = NO;
    _info.adjustsImageWhenHighlighted = NO;
    [_info addTarget:self action:@selector(infoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _info.hidden = YES;
    
    [self.view addSubview:_info];
    
    //添加字幕视图
    _subTitle = [[YKSubtitleView alloc] init];
    _subTitle.backgroundColor = [UIColor clearColor];
    _subTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _subTitle.separatorStyle = UITableViewCellSeparatorStyleNone;
    _subTitle.allowsSelection = NO;
    _subTitle.showsVerticalScrollIndicator = NO;
    _subTitle.dataSource = self;
    _subTitle.delegate = self;
    _subTitle.contentInset = UIEdgeInsetsMake(kSUBTITLE_H, 0, kSUBTITLE_H, 0);
    _subTitle.contentOffset = CGPointMake(0, -kSUBTITLE_H);
    _subTitle.userInteractionEnabled = NO;
    
    [self.view addSubview:_subTitle];
    
    //隐藏状态栏
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
}

- (void)setupSetting
{
    self.view.backgroundColor = RGB(28, 32, 44);
    
    // 设置默认的模式
    self.alreadyMrege = NO;
  
    /*
     真机下需要的代码
     妈的，外国人就是牛逼啊，全靠google!
     */
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [audioSession setActive:NO error:nil];
    
    //隐藏状态栏
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
}



#pragma mark - Private Method
#pragma mark 加载资源
- (void)loadResource {
    
    _start.hidden = NO;
    _info.hidden = NO;
    _back.hidden = NO;
    
    [self loadSubTitleWithURL:[NSURL urlWithMatter:self.matter andType:YKMatterTypeSRT]];
    
    [self playVideoWithURL:[NSURL urlWithMatter:self.matter andType:YKMatterTypeMP4]];
    
    [self subtitleIndicatorAnimation];
}

- (void)playVideoWithURL:(NSURL *)url
{
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    [self.videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
    
}

#pragma mark mrege video&audio
- (void)mregeVideoWithCompletion:(mergeMediaComplete)completion
{
    
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL urlWithMatter:self.matter andType:YKMatterTypeMP4] options:nil];
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL urlWithMatter:self.matter andType:YKMatterTypeRec] options:nil];
    AVURLAsset *bgmAsset = [[AVURLAsset alloc] initWithURL:[NSURL urlWithMatter:self.matter andType:YKMatterTypeMP3] options:nil];
    
    // 合成器
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    // 创建音轨
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *bgmTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // 在音轨中插入资源
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [bgmTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, bgmAsset.duration) ofTrack:[[bgmAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //创建保存路径
    NSString *myPathDocs =  [MY_MEDIA_DIR_STR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",[[NSUUID UUID] UUIDString]]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    

    //创建输出对象
    AVAssetExportSession *export = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    export.outputURL = url;
    export.outputFileType = AVFileTypeQuickTimeMovie;
    export.shouldOptimizeForNetworkUse = YES;
    
    //覆盖本地文件并且更新数据库
    [[NSFileManager defaultManager] removeRepeatFileWithPath:myPathDocs];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    //进行导出视频的操作
    [export exportAsynchronouslyWithCompletionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });

        // 保存数据库
        YKLocationMediaModel *model = [[YKLocationMediaModel alloc] init];
        
        // 赋值
        model.cover = self.matter.img_url;
        model.name = self.matter.title;
        model.origin = self.matter.from;
        model.time = [[NSDate date] getCurrentTime];
        model.url = myPathDocs;
        
        // 开始存储数据
        YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
        [manager insertEntityWithLocationMediaModel:model];
        
        // 合成完毕之后的操作
        completion(model);
        
    }];
}

#pragma mark 按钮点击事件
- (void)startButtonClick
{
    _start.selected ? [_start setSelected:NO] : [_start setSelected:YES];
    self.videoPlayer.rate == 1.0 ? [self onPlayerPause] : [self onPlayerStart];
    
}

- (void)backButtonClick
{
    //退出
    [self exit];
}

- (void)infoButtonClick
{
    [_timeManager invalidate];
}

#pragma mark 播放状态逻辑
- (void)onPlayerPause
{
    [self.videoPlayer pause];
    
    [self.recorder pause];
    
    [self.audioPlayer pause];
    
    [self pauseTimeManager];
}

- (void)onPlayerStart
{
    [self.videoPlayer play];
    
    [self.recorder record];
    
    [self.audioPlayer play];
    
    [self startTimeManager];
}


#pragma mark  退出控制器
- (void)exit
{

    //判断是否已经录音完成
    if (self.alreadyMrege) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要放弃当前配音吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
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
    debugLog(@"完成录音");
    
    //开始合成
    [self mregeVideoWithCompletion:^(YKLocationMediaModel *model) {
        // 设置为已经录制完成
        self.alreadyMrege = YES;
        
        // 友情提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜您，配音成功！" preferredStyle:UIAlertControllerStyleAlert];
        
        // 添加按钮
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 播放刚刚存储的视频
                YKBrowseViewController *vc = [[YKBrowseViewController alloc] initWithURL:[NSURL fileURLWithPath:[MY_MEDIA_DIR_STR stringByAppendingPathComponent:[model valueForKey:@"url"]]]];
                
                [self presentViewController:vc animated:YES completion:nil];
            });
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"待会再看" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:confirm];
        [alert addAction:cancel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _start.selected = NO;
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        });

    }];
    
    //关闭Timer
    [self pauseTimeManager];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    debugLog(@"出错");
}

#pragma mark load subtitle
- (void)loadSubTitleWithURL:(NSURL *)url
{
    _subTitleArray = [NSMutableDictionary dictionary];
    _subTitleTimeArray = [NSMutableArray array];
    
    NSError *error = nil;
    NSString *sourceString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    NSArray *stringArray = [sourceString componentsSeparatedByString:@"\n"];
    
    // 加载时间数组
    for (int i = 0; i < stringArray.count;i++) {
        if ((i - 1) % 4 == 0) {
            
            NSString *temp = stringArray[i];
            
            NSString *result = [temp substringWithRange:NSMakeRange(3, 5)];
            
            [_subTitleTimeArray addObject:result];
        }
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    
    // 加载字幕数组临时
    for (int i = 0; i < stringArray.count;i++) {
        if ((i - 2) % 4 == 0) {
            [temp addObject:stringArray[i]];
        }
    }
    
    // 加载字幕字典
    for (int i = 0; i < MIN(_subTitleTimeArray.count, temp.count); i++) {
        [_subTitleArray setObject:temp[i] forKey:_subTitleTimeArray[i]];
    }
    
    // 刷新
    [_subTitle reloadData];
}

#pragma mark 关于TimeManager的业务逻辑
- (void)startTimeManager
{
    _timeManager = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeManger) userInfo:nil repeats:YES];
    
    [_timeManager fire];
    
}

- (void)pauseTimeManager
{
    [_timeManager invalidate];
}

- (void)updateTimeManger
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    
    //计算当前的播放时间
    double minutesElapsed = floor(_recorder.currentTime / 60);
    double secondsElapsed = fmod(_recorder.currentTime, 60);
    NSString *currentTime = [NSString stringWithFormat:@"%02.f:%02.f",minutesElapsed,secondsElapsed];
    
    //懒加载
    if (!_currentTime) {
        _currentTime = 0;
    }
    
    //防止数组越界
    if ((_currentTime + 1) > [_subTitleArray allKeys].count) {
        return;
    }
    
    //判断当前读取的是哪一行字幕
    if ([[_subTitleArray allKeys] containsObject:currentTime]) {
        
        //获取当前字幕的index
        NSUInteger index = [_subTitleTimeArray indexOfObject:currentTime];
        
        _currentTime = (int)index;
        
        //滚动
        NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:_currentTime inSection:0];
        
        [_subTitle scrollToRowAtIndexPath:toIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
    
    
}

- (void)subtitleIndicatorAnimation {
    

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0, 1, 1, 1);
    
    CGPoint SEPoint[2];
    
    CGContextMoveToPoint(context, SEPoint[0].x, SEPoint[0].y);
    CGContextAddLineToPoint(context, SEPoint[1].x, SEPoint[1].y);
    
    CGContextStrokePath(context);

}

#pragma mark - <TableView DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _subTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"subtitleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        //设置透明
        cell.backgroundColor = [UIColor clearColor];
        //设置居中
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    cell.textLabel.text = [_subTitleArray objectForKey:_subTitleTimeArray[indexPath.row]];
    //设置字体颜色
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

#pragma mark - <TableView Delegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

#pragma mark - ScrollView Delegate


#pragma mark - Property
- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL urlWithMatter:self.matter andType:YKMatterTypeMP3] error:nil];
    }
    return _audioPlayer;
}

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        
        // 录音参数设置
        NSMutableDictionary *recorderSetting = [NSMutableDictionary dictionary];
        
        // 设置保存格式
        [recorderSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        // 设置采样频率
        [recorderSetting setValue:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
        // 设置通道数
        [recorderSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        // 设置采样位数
        [recorderSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        // 设置录音质量
        [recorderSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        // 初始化
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL urlWithMatter:self.matter andType:YKMatterTypeRec] settings:recorderSetting error:nil];
        // 控制音量
        [_recorder peakPowerForChannel:0];
        _recorder.delegate = self;
    }
    return _recorder;
}

- (AVPlayer *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[AVPlayer alloc] init];
        _videoPlayer.muted = YES;
        __weak typeof(self)weakSelf = self;
        [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
            if (weakSelf.videoPlayer.currentItem.duration.value == time.value) {
                [weakSelf.recorder stop];
            }
        }];
    }
    return _videoPlayer;
}

- (AVPlayerLayer *)videoLayer {
    if (!_videoLayer) {
        _videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        _videoLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _videoLayer.anchorPoint = CGPointMake(0, 0);
        _videoLayer.bounds = CGRectMake(0, 0, KwinW, KwinW * 9 / 16);
        _videoLayer.position = CGPointMake(0,0);
        
    }
    return _videoLayer;
}


@end
