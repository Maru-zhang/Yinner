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
#import <MJRefresh/MJRefresh.h>
#import "YKMatterListOperator.h"

@interface YKLocationViewController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation YKLocationViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSetting];
    
    [self setupView];
    
}


#pragma mark - Private Method
- (void)setupSetting {
    self.locationtableView.dataSource = self;
    self.locationtableView.delegate = self;
}

- (void)setupView {
   
    self.locationtableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [self.locationtableView.mj_header beginRefreshing];
}


- (void)loadData{
    
    YKMatterListOperator *operator = [[YKMatterListOperator alloc] init];
    @weakify(self);
    [operator getTopicResponseWithSuccessHandler:^(id responseObject) {
        
        [weak_self.dataSource removeAllObjects];
        
        [weak_self.dataSource addObjectsFromArray:responseObject];
        
        [weak_self.locationtableView reloadData];
        
        [weak_self.locationtableView.mj_header endRefreshing];
    } andFailureHandler:^(NSError *error) {
        [weak_self.locationtableView.mj_header endRefreshing];
    }];
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"locationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    YKMatterModel *model = self.dataSource[indexPath.row];
    
    cell.textLabel.text = model.title;
    
    return cell;
}



#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YKWorkViewController *vc = [[YKWorkViewController alloc] initWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    
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

#pragma mark - Property
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
