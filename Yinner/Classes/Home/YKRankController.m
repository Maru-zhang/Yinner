//
//  YKRankController.m
//  Yinner
//
//  Created by Maru on 15/6/10.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKRankController.h"

@interface YKRankController ()

@end

@implementation YKRankController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private method
- (void)setup
{
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer = @"browseTableCell";
    
    YKBrowseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"YKBrowseTableViewCell" owner:nil options:nil];
        cell = [cellArray lastObject];
    }
    
    //设置排名
    if (indexPath.row == 0) {
        cell.bester.hidden = NO;
        cell.bester.image = [UIImage imageNamed:@"home_crown_gold"];
    }
    else if (indexPath.row == 1)
    {
        cell.bester.hidden = NO;
        cell.bester.image = [UIImage imageNamed:@"home_crown_silver"];
    }
    else if (indexPath.row == 2)
    {
        cell.bester.hidden = NO;
        cell.bester.image = [UIImage imageNamed:@"home_crown_copper"];
    }
    else
    {
        cell.bester.hidden = YES;
    }

    cell.rankNum.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}



@end
