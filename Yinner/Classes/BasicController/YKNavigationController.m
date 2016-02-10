//
//  YKNavigationController.m
//  Yinner
//
//  Created by Maru on 15/12/9.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKNavigationController.h"

@implementation YKNavigationController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView {
    // 设置返回的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    // 设置导航栏颜色
    self.navigationBar.barTintColor = NAVIGATION_COLOR;
    // 导航栏标题颜色
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:NAVIGATION_TITLE_COLOR forKey:NSForegroundColorAttributeName];
}

@end
