//
//  UIAlertController+ShortWay.m
//  Yinner
//
//  Created by apple on 16/1/30.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "UIAlertController+ShortWay.h"

@implementation UIAlertController (ShortWay)

+ (void)showBaseMessage:(NSString *)msg toVC:(UIViewController *)vc completion:(ConfirmHandler)handler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kDefaultTitle message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:kDefaultConfirm style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:confirm];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)showCommonMessage:(NSString *)msg toVC:(UIViewController *)vc completion:(ConfirmHandler)handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kDefaultTitle message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:kDefaultConfirm style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:kDefaultCancel style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:confirm];
    [alert addAction:cancel];
    
    [vc presentViewController:alert animated:YES completion:nil];
    
}



@end
