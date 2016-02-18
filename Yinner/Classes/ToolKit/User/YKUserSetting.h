//
//  YKUserSetting.h
//  Yinner
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const PlayerSettingKey_US = @"playSetting_US";
static NSString *const MessagePushKey_US = @"messagePush_US";
static NSString *const PrivateMessageKey_US = @"privateMsg_US";


@interface YKUserSetting : NSObject

+ (NSInteger)getPlayerSetting;
+ (void)setPlayerSetting:(NSInteger)setting;

+ (BOOL)getAllowMessagePush;
+ (void)setAllowMessagePush:(BOOL)push;
+ (BOOL)getAllowPrivateMessage;
+ (void)setAllowPrivateMessage:(BOOL)msg;


@end
