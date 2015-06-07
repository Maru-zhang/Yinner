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
    
    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    [self setupView];
}

#pragma mark - setup
- (void)setupView
{
    YKHomeSelectView *seletView = [[YKHomeSelectView alloc] initWithFrame:CGRectMake(0, kNavH, KwinW,100)];
    YKHomeSelectView *seletView = [[YKHomeSelectView alloc] initWithFrame:CGRectMake(0,10, KwinW,100)];
    
    seletView.backgroundColor = [UIColor whiteColor];
    
    //添加子图标
    [seletView addChildButtonWithName:@"home_heart.png" andColor:[UIColor colorWithRed:1.000 green:0.400 blue:0.400 alpha:1.000] andTitleName:@"喜爱"];
    [seletView addChildButtonWithName:@"home_list.png" andColor:[UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000] andTitleName:@"频道"];
    [seletView addChildButtonWithName:@"home_rank.png" andColor:[UIColor colorWithRed:0.800 green:0.400 blue:1.000 alpha:1.000] andTitleName:@"排行"];
    
    [seletView addChildButtonWithName:@"home_heart.png" andColor:[UIColor redColor]];
    [seletView addChildButtonWithName:@"home_list.png" andColor:[UIColor redColor]];
    [seletView addChildButtonWithName:@"home_rank.png" andColor:[UIColor redColor]];
    //调整坐标
    [seletView adjustAllChildButton];
    
    [self.view addSubview:seletView];
}

@end
