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
#import "YKMatterModel.h"

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"locationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"后会无期";
    
    return cell;
}



#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YKMatterModel *model = [[YKMatterModel alloc] init];
    
    model.title = @"后会无期";
    model.zipURL = [NSURL URLWithString:@"http://7xp4ku.com1.z0.glb.clouddn.com/201411171813a004c168398c20bb.zip"];
    
    YKWorkViewController *vc = [[YKWorkViewController alloc] initWithModel:model];
    
    [self presentViewController:vc animated:YES completion:nil];
    
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
