//
//  YKHomeViewController.m
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKHomeViewController.h"

@interface YKHomeViewController ()

@end

@implementation YKHomeViewController

#pragma makr - life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    [self setupView];
}

#pragma mark - setup
- (void)setupView
{
    YKHomeSelectView *seletView = [[YKHomeSelectView alloc] initWithFrame:CGRectMake(0, kNavH, KwinW,100)];
    
    [seletView addChildButtonWithName:@"home_heart.png" andColor:[UIColor redColor]];
    [seletView addChildButtonWithName:@"home_list.png" andColor:[UIColor redColor]];
    [seletView addChildButtonWithName:@"home_rank.png" andColor:[UIColor redColor]];
    
    [self.view addSubview:seletView];
}

@end
