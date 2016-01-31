//
//  UIAlertController+ShortWay.h
//  Yinner
//
//  Created by apple on 16/1/30.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultTitle @"温馨提示"
#define kDefaultConfirm @"确定"
#define kDefaultCancel @"取消"

typedef void(^ConfirmHandler)();


@interface UIAlertController (ShortWay)

+ (void)showBaseMessage:(NSString *)msg toVC:(UIViewController *)vc completion:(ConfirmHandler)handler;
+ (void)showCommonMessage:(NSString *)msg toVC:(UIViewController *)vc completion:(ConfirmHandler)handler;

@end
