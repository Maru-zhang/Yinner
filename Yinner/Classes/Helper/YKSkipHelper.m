//
//  YKSkipHelper.m
//  Yinner
//
//  Created by apple on 16/2/7.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKSkipHelper.h"
#import "YKPersonInfoController.h"
#import "YKModaController.h"

@implementation YKSkipHelper


+ (UITabBarController *)getTopTabbarController {
    return (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
}

+ (void)skipToHeadImageSetting {
    
    YKPersonInfoController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"YKPersonInfoController"];
    
    YKModaController *nav = [[YKModaController alloc] initWithRootViewController:vc];
                  
    [[self getTopTabbarController] presentViewController:nav animated:YES completion:nil];
    
}

@end
