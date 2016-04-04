//
//  YKBrowseViewController.m
//  Yinner
//
//  Created by Maru on 15/7/25.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKBrowseViewController.h"
#import "KRVideoPlayerController+Hidden.h"
#import <AVFoundation/AVFoundation.h>
#import "YKCommentOperator.h"
#import "YKCommentModel.h"

@interface YKBrowseViewController ()
{
    UITableView *_commentView;
    UIButton *_testButton;
    YKBrowseAuthorInfoView *_infoView;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation YKBrowseViewController

#pragma mark - 构造方法
- (instancetype)initWithURL:(NSURL *)url {
    if (self == [super init]) {
        self.videoURL = url;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self setupView];
    
    // 初始化设置
    [self setupSetting];
    
    // 加载评论
    [self loadComment:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self playVideoWithURL:self.videoURL];
    
    [self.videoPlayer hiddenCloseButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 检测设置和网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    __weak typeof(self)weakSelf = self;
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSInteger integer = [YKUserSetting getPlayerSetting];
        
        if (integer == 0 && status == AFNetworkReachabilityStatusReachableViaWiFi) {
            [weakSelf.videoPlayer play];
        }else if (integer == 1 && status == AFNetworkReachabilityStatusReachableViaWWAN) {
            [weakSelf.videoPlayer play];
        }else if (integer == 2) {
        }else if (status == AFNetworkReachabilityStatusNotReachable) {
            [SVProgressHUD showErrorWithStatus:@"网路链接失败！"];
        }
            
    }];
    
    [manager startMonitoring];
}


#pragma mark - Autolaout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //给评论区添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_commentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:KwinW / 16 * 9 + 110]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_commentView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_commentView
                                                          attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:5]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_commentView
                                                          attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-5]];
    
    //给信息区添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:KwinW / 16 * 9 + 10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoView
                                                          attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoView
                                                          attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:-self.view.frame.size.height + 90]];
    
}

#pragma mark - Private Method
- (void)setupView
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.877 alpha:1.000];
    
    if (!_commentView) {
        
        _commentView = [[UITableView alloc] init];
        _commentView.translatesAutoresizingMaskIntoConstraints = NO;
        _commentView.showsVerticalScrollIndicator = NO;
        _commentView.tableFooterView = [UIView new];
        _commentView.dataSource = self;
        _commentView.delegate = self;
        
        [self.view addSubview:_commentView];
        
    }
    
    if (!_infoView) {
        _infoView = [[[NSBundle mainBundle] loadNibNamed:@"YKBrowseAuthorInfoView" owner:self options:nil] lastObject];
        _infoView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:_infoView];
    }
    
}

- (void)setupSetting
{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sesstionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sesstionError];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(exitController)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}



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
    
}

- (void)loadComment:(BOOL)setup {
    
    YKCommentOperator *operator = [[YKCommentOperator alloc] init];
    
    @weakify(self)
    [operator fetchCommentResponseWithSuccessHandler:^(NSMutableArray *resultArray) {
        
        @strongify(self)
        
        [self.dataSource addObjectsFromArray:resultArray];
        
        [_commentView reloadData];
        
    } andFailureHandler:^(NSError *error) {
        
    }];
    
}

#pragma mark 退出
- (void)exitController
{
    [self.videoPlayer dismiss];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 重写方法
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - <UITableview Datasource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"commentCell";
    static NSString *totalIdentifer = @"totalCommentCell";
    
    //分情况返回Cell
    if (indexPath.row == 0) {
        UITableViewCell *totalCell = [tableView dequeueReusableCellWithIdentifier:totalIdentifer];
        
        totalCell = [[UITableViewCell alloc] init];
        totalCell.textLabel.text = [NSString stringWithFormat:@"共有%lu条评论",(unsigned long)self.dataSource.count];
        totalCell.textLabel.textColor = [UIColor grayColor];
        
        return totalCell;
    }
    else
    {
        YKCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        
        if (!cell) { cell = [[[NSBundle mainBundle] loadNibNamed:@"YKCommentTableViewCell" owner:self options:nil] lastObject]; }
        
        YKCommentItem *item = self.dataSource[indexPath.row];
        
        cell.name.text = item.username;
        cell.content.text = item.content;
        cell.commentTime.text = [item.date substringFromIndex:1];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:item.userhead]];
        
        debugLog(@"%@",item);
        
        return cell;
    }
    
}

#pragma mark - <TableView Delegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return 30;
    }
    else
    {
        return 55;
    }
}

#pragma mark - Property
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
