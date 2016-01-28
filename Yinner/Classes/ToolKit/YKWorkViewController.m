//
//  YKWorkViewController.m
//  Yinner
//
//  Created by Maru on 15/5/27.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKWorkViewController.h"
#import "KRVideoPlayerController+Hidden.h"
#import "YKSubtitleView.h"
#import "YKBrowseViewController.h"
#import "YKLocationViewController.h"
#import "NSURL+File.h"
#import <AVFoundation/AVFoundation.h>

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
/** 录音器 */
@property (nonatomic,strong)  AVAudioRecorder *recorder;
/** 背景音乐播放器 */
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
/** 时间器 */
@property (nonatomic,weak) NSTimer *timeManager;
@end

@implementation YKWorkViewController

#pragma mark - 构造方法
- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        self.videoURL = url;
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
    NSString *localPath = [ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:[self.zipURL lastPathComponent]];
    
    // 检查是否已经缓存完毕
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        
        [self loadResource];
        
    }else {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.zipURL];
        
        AFHTTPRequestOperation *operator = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        // 设置输出路径
        operator.outputStream = [NSOutputStream outputStreamToFileAtPath:localPath append:NO];
        
        // 下载中块
        [operator setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            [SVProgressHUD showProgress:totalBytesRead / totalBytesExpectedToRead status:@"正在下载素材..." maskType:SVProgressHUDMaskTypeGradient];
        }];
        
        // 完成操作
        [operator setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            debugLog(@"-----%@",localPath);
            [SVProgressHUD dismiss];
            
            // 解压操作
            ZZArchive *archive = [ZZArchive archiveWithURL:[NSURL fileURLWithPath:localPath] error:nil];
            
            // 创建解压文件夹
            NSString *unarchivePath = [ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:[[localPath lastPathComponent] stringByDeletingPathExtension]];
            
            [[NSFileManager defaultManager] createDirectoryAtPath:unarchivePath withIntermediateDirectories:NO attributes:nil error:nil];
            
            // 循环解压
            for (ZZArchiveEntry* entry in archive.entries)
            {
                NSURL* targetPath = [[NSURL fileURLWithPath:unarchivePath] URLByAppendingPathComponent:entry.fileName];
                
                [[entry newDataWithError:nil] writeToURL:targetPath
                                                  atomically:NO];
            }
            
            [self loadResource];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"下载失败!" maskType:SVProgressHUDMaskTypeGradient];
        }];
        
        // 开始操作
        [operator start];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timeManager invalidate];
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

#pragma mark 设置是否为观看模式
- (void)setWatchModel:(BOOL)watchModel
{
    //赋值
    _watchModel = watchModel;
    
    if (watchModel) {
        [self.videoPlayer hiddenCloseButton];
        _start.hidden = YES;
        _back.hidden =YES;
        _info.hidden = YES;
    }
    else
    {
        [self.videoPlayer hiddenControlButton];
        _start.hidden = NO;
        _back.hidden = NO;
        _info.hidden = NO;
    }
}

#pragma mark - 初始化
- (void)setupView
{
    //添加开始、暂停按钮
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
    
    [self.view addSubview:_subTitle];
    
}

- (void)setupSetting
{
    self.view.backgroundColor = RGB(28, 32, 44);
    
    //添加返回手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(exit)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    //隐藏状态栏
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    //设置默认的模式
    self.alreadyMrege = NO;
    self.watchModel = NO;
    
    //真机下需要的代码
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [session setActive:YES error:nil];
    
}



#pragma mark - Private Method
#pragma mark 加载资源
- (void)loadResource {
    
    _start.hidden = NO;
    _info.hidden = NO;
    _back.hidden = NO;
    
    [self loadSubTitleWithURL:[NSURL getMaterialByZipURL:self.zipURL andType:@"srt"]];
    
    [self playVideoWithURL:[NSURL getMaterialByZipURL:self.zipURL andType:@"mp4"]];
}

- (void)playVideoWithURL:(NSURL *)url
{
    if (!_videoPlayer) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _videoPlayer = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width * (9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoPlayer setDimissCompleteBlock:^{
            weakSelf.videoPlayer = nil;
        }];
        
        [self.videoPlayer showInWindow];
    }
    self.videoPlayer.contentURL = url;
    
    [self.videoPlayer hiddenControlButton];
    
    //完成播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStart) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStop) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    
}

- (void)playerStart
{
    [self startAudioRecordWithName:nil andDuration:0];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:1];
    NSDateFormatter *fotmatter = [[NSDateFormatter alloc] init];
    [fotmatter dateFromString:@"HH：mm"];
    NSString *time = [fotmatter stringFromDate:date];
    NSLog(@"%@",date);
    NSLog(@"test:%@",time);
    
}

- (void)playerStop
{
    if (self.watchModel) {
        return;
    }
    [self.recorder stop];
    
    [self pauseTimeManager];
}

#pragma mark mrege video&audio
- (void)mregeWithVideo:(NSURL *)videoURL andAudio:(NSURL *)audioURL completion:(mergeMediaComplete)completion
{
    
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL getMaterialByZipURL:self.zipURL andType:@"mp4"] options:nil];
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL getMaterialByZipURL:self.zipURL andType:@"wav"] options:nil];
    AVURLAsset *bgmAsset = [[AVURLAsset alloc] initWithURL:[NSURL getMaterialByZipURL:self.zipURL andType:@"mp3"] options:nil];
    
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
    NSString *myPathDocs =  [MY_MEDIA_DIR_STR stringByAppendingPathComponent:[NSString stringWithFormat:@"%f_%@",[[NSDate date] timeIntervalSinceNow],[videoURL lastPathComponent]]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    debugLog(@"%@",[url filePathURL]);
    
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
        model.cover = myPathDocs;
        model.name = [[videoURL lastPathComponent] stringByDeletingPathExtension];
        model.origin = @"音控";
        model.time = [[NSDate date] getCurrentTime];
        model.titleurl = [url lastPathComponent];
        model.url = [url lastPathComponent];
        
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
    _videoPlayer.playbackState == MPMoviePlaybackStatePlaying ?[self onPlayerPause]: [self onPlayerStart];
    [self setWatchModel:NO];
    
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
    [_videoPlayer pause];
    
    [self.recorder pause];
    
    [self.audioPlayer pause];
    
    [self pauseTimeManager];
}

- (void)onPlayerStart
{
    [_videoPlayer play];
    
    [self.recorder record];
    
    [self.audioPlayer play];
    
    [self startTimeManager];
}

#pragma mark audio record
- (void)startAudioRecordWithName:(NSString *)name andDuration:(NSTimeInterval)duration
{
    // 开始录音
    [self.recorder record];
}



#pragma mark  退出控制器
- (void)exit
{
    //判断是否为观赏模式
    if (self.watchModel) {
        [_videoPlayer dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"判断");
        return;
    }

    //判断是否已经录音完成
    if (self.alreadyMrege) {
        [_videoPlayer dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要放弃当前配音吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
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
    [self mregeWithVideo:_videoURL andAudio:_audioURL completion:^(YKLocationMediaModel *model) {
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
    for (int i = 0; i < _subTitleTimeArray.count; i++) {
        [_subTitleArray setObject:temp[i] forKey:_subTitleTimeArray[i]];
    }
    
    // 刷新
    [_subTitle reloadData];
    
    NSLog(@"测试：%@",stringArray);
    NSLog(@"时间测试:%@",_subTitleTimeArray);
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
    NSLog(@"正在播放----------------%f",_recorder.currentTime);
    
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
    if ((_currentTime + 1) > _subTitleTimeArray.count) {
        return;
    }
    
    //滚动
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:_currentTime inSection:0];
    
    [_subTitle scrollToRowAtIndexPath:toIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //判断当前读取的是哪一行字幕
    if ([_subTitleTimeArray containsObject:currentTime]) {
        
        //获取当前字幕的index
        NSUInteger index = [_subTitleTimeArray indexOfObject:currentTime];
        
        _currentTime = (int)index;
        
    }
    
    
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
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL getMaterialByZipURL:self.zipURL andType:@"mp3"] error:nil];
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
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL getMaterialByZipURL:self.zipURL andType:@"wav"] settings:recorderSetting error:nil];
        // 控制音量
        [_recorder peakPowerForChannel:0];
        _recorder.delegate = self;
    }
    return _recorder;
}



@end
