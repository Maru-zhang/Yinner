//
//  YKModaController.m
//  Yinner
//
//  Created by apple on 16/2/6.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKModaController.h"

@implementation YKModaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupView];
}


#pragma mark - Private Methpd
- (void)setupView {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
    
    // 标题颜色
    [item setTintColor:[UIColor whiteColor]];
    
    // 返回颜色
    [self.navigationBar setTintColor:NAVIGATION_TITLE_COLOR];
    
    // 关闭按钮
    [self.topViewController.navigationItem setLeftBarButtonItem:item];
    
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
