//
//  KRVideoPlayerController+Hidden.m
//  Yinner
//
//  Created by Maru on 15/12/9.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "KRVideoPlayerController+Hidden.h"
#import <KRVideoPlayer/KRVideoPlayerControlView.h>
#import <objc/runtime.h>

@implementation KRVideoPlayerController (Hidden)
- (void)hiddenControlButton {
    KRVideoPlayerControlView *controlView = [self valueForKey:@"videoControl"];
    controlView.closeButton.hidden = YES;
    controlView.playButton.hidden = YES;
    controlView.pauseButton.hidden = YES;
    controlView.fullScreenButton.hidden = YES;
}

- (void)hiddenCloseButton {
    KRVideoPlayerControlView *controlView = [self valueForKey:@"videoControl"];
    controlView.closeButton.hidden = YES;
}

@end
