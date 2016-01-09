//
//  YKWorksListController.m
//  Yinner
//
//  Created by Maru on 15/12/27.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKWorksListController.h"

@implementation YKWorksListController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}


#pragma mark - Private Method
- (void)setupView {
    self.title = @"作品列表";
}

@end
