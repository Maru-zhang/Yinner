//
//  YKFansListController.m
//  Yinner
//
//  Created by Maru on 15/12/27.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKFansListController.h"

@implementation YKFansListController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}


#pragma mark - Private Method
- (void)setupView {
    self.title = @"粉丝列表";
}

@end
