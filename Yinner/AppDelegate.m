//
//  AppDelegate.m
//  Yinner
//
//  Created by Maru on 15/5/19.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "AppDelegate.h"
#import "YKLoginViewController.h"
#import "ReuseKey.h"

@interface AppDelegate () <EMChatManagerBuddyDelegate>

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 设置全局样式
    [self setupAppearance];
    
    // 设置全局配置
    [self setupSetting];
    
    //获取APNS文件的名字
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"chatdemoui_dev";
#else
    apnsCertName = @"chatdemoui";
#endif
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"easemob-demo#chatdemoui" apnsCertName:apnsCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //自动获取好友列表
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    //添加代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - EMChatManagerDelegate
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    NSMutableArray *requestArray = [[NSUserDefaults standardUserDefaults] objectForKey:KfriendRequest];
    
    if (!requestArray) {
        
        requestArray = [NSMutableArray array];
    }
    
    //如果其中包含该请求那么就返回
    if ([requestArray containsObject:@{@"username" : username,@"message" : message}]) {
        return;
    }
    
    NSDictionary *dic = @{@"username" : username,@"message" : message};
    
    [requestArray addObject:dic];
    
    [[NSUserDefaults standardUserDefaults] setObject:requestArray forKey:KfriendRequest];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KNotification_ReloadData object:nil]];
}

#pragma mark - Setup
- (void)setupAppearance {
    
    // 点击以后的反应
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    // 导航栏颜色
    [[UINavigationBar appearance] setBarTintColor:NAVIGATION_COLOR];
    // 导航栏标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NAVIGATION_TITLE_COLOR,NSForegroundColorAttributeName,nil]];
    // 状态栏的样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)setupSetting {
    
    BOOL yes = nil;
    
    // 检查是否存在源文件夹，如果不存在那么就创建
    if (![[NSFileManager defaultManager] fileExistsAtPath: ORIGIN_MEDIA_DIR_STR isDirectory:&yes]) {
        debugLog(@"新建文件夹-%@",ORIGIN_MEDIA_DIR_STR);
        [[NSFileManager defaultManager] createDirectoryAtPath:ORIGIN_MEDIA_DIR_STR withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    // 是否存在本地媒体文件夹，如果不存在，那么创建
    if (![[NSFileManager defaultManager] fileExistsAtPath: MY_MEDIA_DIR_STR isDirectory:&yes]) {
        debugLog(@"新建文件夹-%@",MY_MEDIA_DIR.absoluteString);
        [[NSFileManager defaultManager] createDirectoryAtPath:MY_MEDIA_DIR_STR withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

@end
