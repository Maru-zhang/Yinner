//
//  YKFriendController.m
//  Yinner
//
//  Created by Maru on 15/7/6.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKFriendController.h"

@interface YKFriendController ()

@end

@implementation YKFriendController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}


#pragma mark - Private Method
- (void)setupView
{
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AliCry"]];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

@end
