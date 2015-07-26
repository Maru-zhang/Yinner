//
//  YKWorkViewController.h
//  Yinner
//
//  Created by Maru on 15/5/27.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import <KRVideoPlayer/KRVideoPlayerController.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "YKLocationMediaModel.h"
#import "YKCoreDataManager.h"
#import "NSDate+Current.h"
#import "NSFileManager+Repeat.h"
#import "NSString+FileName.h"
#import "NSString+File.h"
#import "ReuseFrame.h"

@interface YKWorkViewController : UIViewController <AVAudioRecorderDelegate,UITableViewDataSource,UITableViewDelegate>

singleton_interface(YKWorkViewController)

@property (nonatomic) BOOL watchModel;
@property (nonatomic) BOOL alreadyMrege;
@property (nonatomic,strong) NSURL *audioURL;
@property (nonatomic,strong) NSURL *videoURL;
@property (nonatomic,strong) KRVideoPlayerController *videoPlayer;

+ (YKWorkViewController *)WorkViewControllerWithURL:(NSURL *)url;

@end
