//
//  YKBrowseViewController.h
//  Yinner
//
//  Created by Maru on 15/7/25.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KRVideoPlayer/KRVideoPlayerController.h>
#import "Singleton.h"
#import "ReuseFrame.h"

@interface YKBrowseViewController : UIViewController

singleton_interface(YKBrowseViewController)

@property (nonatomic,strong) NSURL *videoURL;
@property (nonatomic,strong) KRVideoPlayerController *videoPlayer;
@property (nonatomic,strong) UITableView *tableView;

+ (YKBrowseViewController *)browseViewcontrollerWithUrl:(NSURL *)url;

@end
