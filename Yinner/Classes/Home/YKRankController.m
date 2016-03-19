//
//  YKRankController.m
//  Yinner
//
//  Created by Maru on 15/6/10.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKRankController.h"
#import "YKRankListModel.h"
#import "YKRankListOperator.h"

@interface YKRankController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithSetup:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadDataWithSetup:NO];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark Load New Data
- (void)loadDataWithSetup:(BOOL)setup
{
    YKRankListOperator *operator = [[YKRankListOperator alloc] init];
    
    [operator getWithpageNum:1 SuccessHander:^(NSMutableArray *resultArray) {
        
        if (setup) {
            [self.dataSource removeAllObjects];
        }
        
        [self.dataSource addObjectsFromArray:resultArray];
        
        [self.tableView reloadData];
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } andFailHander:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithEmptyMsg:@"没有相应的数据!" ifNecessaryForDataCount:[self.dataSource count]];
    return self.dataSource.count;
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
    
    // 配置cell
    YKRankListModel *model = self.dataSource[indexPath.row];
    
    [cell.breviaryImage sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.title.text = model.title;
    cell.startCount.text = [NSString stringWithFormat:@"%ld",(long)model.good_count];
    cell.commentCount.text = [NSString stringWithFormat:@"%ld",(long)model.forward_count];
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Property
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end
