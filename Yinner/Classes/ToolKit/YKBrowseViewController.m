//
//  YKBrowseViewController.m
//  Yinner
//
//  Created by Maru on 15/7/25.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKBrowseViewController.h"

@interface YKBrowseViewController ()
{
    UITableView *_tableView;
    UIButton *_testButton;
    YKBrowseAuthorInfoView *_infoView;
}
@end

@implementation YKBrowseViewController

singleton_implementation(YKBrowseViewController)

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化视图
    [self setupView];
    
    //初始化设置
    [self setupSetting];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self playVideoWithURL:self.videoURL];
}

#pragma mark - Autolaout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //给评论区添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:KwinW / 16 * 9 + 110]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:5]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    
    //给信息区添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:KwinW / 16 * 9 + 10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-self.view.frame.size.height + 90]];
    
}

#pragma mark - 工厂方法
+ (YKBrowseViewController *)browseViewcontrollerWithUrl:(NSURL *)url
{
    YKBrowseViewController *browseVC = [YKBrowseViewController sharedYKBrowseViewController];
    
    browseVC.videoURL = url;
    
    [browseVC.videoPlayer showWorkButton];
    
    return browseVC;
    
}

#pragma mark - Private Method
- (void)setupView
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.877 alpha:1.000];
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [self.view addSubview:_tableView];
        
    }
    
    if (!_infoView) {
        _infoView = [[[NSBundle mainBundle] loadNibNamed:@"YKBrowseAuthorInfoView" owner:self options:nil] lastObject];
        _infoView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:_infoView];
    }
    
}

- (void)setupSetting
{
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"commentCell";
    static NSString *totalIdentifer = @"totalCommentCell";
    
    //分情况返回Cell
    if (indexPath.row == 0) {
        UITableViewCell *totalCell = [tableView dequeueReusableCellWithIdentifier:totalIdentifer];
        
        totalCell = [[UITableViewCell alloc] init];
        totalCell.textLabel.text = @"共有201条评论";
        totalCell.textLabel.textColor = [UIColor grayColor];
        
        return totalCell;
    }
    else
    {
        YKCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YKCommentTableViewCell" owner:self options:nil] lastObject];
        }
        
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

@end
