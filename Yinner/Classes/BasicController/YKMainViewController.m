//
//  MainViewController.m
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKMainViewController.h"
#import "ReuseFrame.h"

@interface YKMainViewController ()
{
    YKPersonnalView *_siderView;
    UIView *_maskView;
}

@end

@implementation YKMainViewController

#pragma mark - life cycle


- (void)viewDidLoad {
    
    //主线程休眠，让启动页面延长时间

    [NSThread sleepForTimeInterval:1];
    
    [super viewDidLoad];
    
    [self cteateAllController];
 
    [self settingDock];
    
    [self setupGestureRecognizer];
    
    [self setupSetting];
}


#pragma mark - Private Method
- (void)setupSetting
{
    self.title = @"音控";
    
    //设置返回的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置状态栏样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //设置默认的slider
    self.isSlidering = NO;
    
    //默认初始化的视图
    _currentIndex = 2;
    [self selectDockItemAt:0];
    
}
- (void)setupGestureRecognizer
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] init];
    UIPanGestureRecognizer *recognizerleft = [[UIPanGestureRecognizer alloc] init];
//    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    recognizerleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [recognizer addTarget:self action:@selector(showPersonalView:)];
    [recognizerleft addTarget:self action:@selector(dismissPersonnalView:)];
    [self.navigationController.view.window addGestureRecognizer:recognizer];
    [self.navigationController.view.window addGestureRecognizer:recognizerleft];
}

- (void)showPersonalView:(UIPanGestureRecognizer *)pan
{
    self.isSlidering = YES;
    
    if (_siderView == nil) {
        _siderView = [[[NSBundle mainBundle] loadNibNamed:@"YKPersonnalView" owner:self options:nil] lastObject];
        _siderView.center = CGPointMake(125, KwinH * 0.5);
        _siderView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
        _siderView.delegate = self;
        [self.view.window addSubview:_siderView];
        [self.view.window sendSubviewToBack:_siderView];
        //创建背景界面
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        bgImageView.image = [UIImage imageNamed:@"sidebar_bg"];
        [self.view.window insertSubview:bgImageView belowSubview:_siderView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.view.center = CGPointMake((KwinW / 2) + 200, KwinH / 2);
        self.navigationController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        _siderView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
    
    NSLog(@"%@",NSStringFromCGPoint([pan translationInView:self.view.window]));
    
}

- (void)dismissPersonnalView:(UIPanGestureRecognizer *)pan
{
    self.isSlidering = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.view.center = CGPointMake(KwinW / 2, KwinH / 2);
        self.navigationController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        _siderView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
    }];
}


#pragma mark - 创建所有的子控制器
- (void)cteateAllController
{
    YKHomeViewController *home = [[YKHomeViewController alloc] init];
    YKPlayViewController *play = [[self storyboard] instantiateViewControllerWithIdentifier:@"play"];
    YKLibraryController *more = [[YKLibraryController alloc] init];
    
    [self addChildViewController:home];
    [self addChildViewController:play];
    [self addChildViewController:more];
    
    //添加自定义代理方法
    home.delegate = self;
}


#pragma mark - 初始化图标
- (void)settingDock
{
    //添加item
    [_dock addDockItemWithIcon:@"tabbar_home.png" title:@"首页"];
    [_dock addDockItemWithIcon:@"Icon-40.png" title:@""];
    [_dock addDockItemWithIcon:@"tabbar_more.png" title:@"音库"];
    
    //监听按钮的点击
    _dock.itemClickBlock = ^(int index)
    {
        [self selectDockItemAt:index];
    };
    
}

#pragma mark 选中的方法
- (void)selectDockItemAt:(int)index
{
    NSLog(@"%d 子视图的数量 %ld",index,self.view.subviews.count);
    if (_currentIndex == index) {
        return;
    }
    
    //进入主功能界面
    switch (index) {
        case 0:
        
            break;
        case 1:
            [self performSegueWithIdentifier:@"play" sender:self];
            return;
            break;
        case 2:
            
            break;
        default:
            break;
    }
    
    //换成新的视图
    UIView *view = [self.childViewControllers[index] view];
    [self.view addSubview:view];
    
    //调整位置
    [self.view bringSubviewToFront:_dock];
    
    _currentIndex = index;
    
}

#pragma mark - homevcDelegate
- (void)homeControllerItemClickAtIndex:(int)index
{
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"favourite" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"channel" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"rank" sender:nil];
            break;
        default:
            break;
    }
}

#pragma mark - personnalvcDelegate
- (void)personnalSettingClick
{
    [self dismissPersonnalView:nil];
    
    [self performSegueWithIdentifier:@"setting" sender:self];
}

- (void)personnalHomeClick
{
    [self dismissPersonnalView:nil];
}

- (void)personnalFriendClick
{
    [self dismissPersonnalView:nil];
    
    [self performSegueWithIdentifier:@"friend" sender:self];
}

- (void)personnalMessageClick
{
    [self dismissPersonnalView:nil];
    
    [self performSegueWithIdentifier:@"message" sender:self];
}

#pragma mark - Get&Set
- (void)setIsSlidering:(BOOL)isSlidering
{
    
    if (isSlidering) {
        _maskView = [[UIView alloc] initWithFrame:self.view.frame];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.1;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPersonnalView:)];
        [_maskView addGestureRecognizer:recognizer];
        [self.navigationController.view addSubview:_maskView];
    }
    else
    {
        [_maskView removeFromSuperview];
    }
    
    
}


- (IBAction)personMeno:(id)sender {
    
    if (_isSlidering) {
        [self dismissPersonnalView:nil];
    }
    else
    {
        [self showPersonalView:nil];
    }
}
@end
