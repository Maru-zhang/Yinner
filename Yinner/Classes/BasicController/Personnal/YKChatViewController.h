//
//  YKChatViewController.h
//  Yinner
//
//  Created by Maru on 15/8/6.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKChatViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>
/** 对话者ID */
@property (nonatomic,copy) NSString *chatter;
/** 对话类型 */
@property (nonatomic) EMConversationType conversationType;

+ (YKChatViewController *)chatViewControllerWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

@end
