//
//  YKWorkViewController.m
//  Yinner
//
//  Created by Maru on 15/5/27.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKLocationViewController.h"
#import "YKWorkViewController.h"
#import "UIView+GrayLine.h"

@interface YKLocationViewController ()

@end

@implementation YKLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationtableView.dataSource = self;
    self.locationtableView.delegate = self;
    
}



#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"locationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"example";
    
    return cell;
}



#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YKWorkViewController *player = [[YKWorkViewController alloc] initWithURL:[NSURL URLWithString:@"http://7xp4ku.com1.z0.glb.clouddn.com/201411171813a004c168398c20bb.zip"]];
    [self presentViewController:player animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView getGrayLine];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}
@end
