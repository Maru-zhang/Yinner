//
//  YKBrowseViewController.m
//  Yinner
//
//  Created by Maru on 15/7/25.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKBrowseViewController.h"

@interface YKBrowseViewController ()

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

#pragma mark - 工厂方法
+ (YKBrowseViewController *)browseViewcontrollerWithUrl:(NSURL *)url
{
    YKBrowseViewController *browseVC = [YKBrowseViewController sharedYKBrowseViewController];
    
    browseVC.videoURL = url;
    
    [browseVC playVideoWithURL:url];
    
    [browseVC.videoPlayer showWorkButton];
    
    return browseVC;
    
}

#pragma mark - Private Method
- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KwinW * (9/16), KwinW, KwinH - KwinW * (9 / 16))];
        
        [self.view addSubview:_tableView];
    }
}

- (void)setupSetting
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(exitController)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe];
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
@end
