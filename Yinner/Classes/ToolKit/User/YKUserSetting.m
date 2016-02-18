//
//  YKUserSetting.m
//  Yinner
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKUserSetting.h"

@implementation YKUserSetting


#pragma mark - 播放设置
+ (NSInteger)getPlayerSetting {
    
    NSInteger result = [[NSUserDefaults standardUserDefaults] integerForKey:PlayerSettingKey_US];
    
    if (result) {
        return result;
    }else {
        [self setPlayerSetting:0];
        return 0;
    }
}

+ (void)setPlayerSetting:(NSInteger)setting {
    [[NSUserDefaults standardUserDefaults] setInteger:setting forKey:PlayerSettingKey_US];
}

#pragma mark - 消息设置

+ (void)setAllowMessagePush:(BOOL)push {
    [[NSUserDefaults standardUserDefaults] setBool:push forKey:MessagePushKey_US];
}

+ (BOOL)getAllowMessagePush {
    
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:MessagePushKey_US];
    
    return result;
}

+ (void)setAllowPrivateMessage:(BOOL)msg {
    [[NSUserDefaults standardUserDefaults] setBool:msg forKey:PrivateMessageKey_US];
}

+ (BOOL)getAllowPrivateMessage {
    
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:PrivateMessageKey_US];
    
    return result;
}


@end
