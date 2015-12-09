//
//  YKMessageController.m
//  Yinner
//
//  Created by Maru on 15/7/6.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKMessageController.h"
#import "YKApplyRequestCell.h"
#import "UITableView+EmptyData.h"

@interface YKMessageController ()

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation YKMessageController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDataSource];
    
    [self setupView];
    
    [self setupSetting];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_ReloadData object:nil];
}

#pragma mark - Private Method
- (void)setupView
{
    //设置分离器的样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



#pragma mark - Private Method
- (void)setupSetting
{
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataSource) name:KNotification_ReloadData object:nil];
}

- (void)loadDataSource
{
    //本地化加载好友请求
    NSMutableArray *requestArray = [[NSUserDefaults standardUserDefaults] objectForKey:KfriendRequest];
    
    if (requestArray) {
        
        [self.dataSource addObjectsFromArray:requestArray];
        
        [self.tableView reloadData];
        
    }
}

#pragma mark 同意和拒绝操作
- (void)acceptRequestWithTig:(UIButton *)btn
{
    EMError *error = nil;
    
    NSDictionary *dic = _dataSource[btn.tag];
    
    NSString *name = [dic objectForKey:@"username"];
    
    [[EaseMob sharedInstance].chatManager acceptBuddyRequest:name error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    };
    
    NSLog(@"%ld",btn.tag);
    
    NSMutableArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:KfriendRequest];
    
    [data removeObject:dic];
    
    //重新存储
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KfriendRequest];
    
    [self loadDataSource];
}

- (void)rejectRequestWithTig:(UIButton *)btn
{
    EMError *error = nil;
    
    NSDictionary *dic = _dataSource[btn.tag];
    
    NSString *name = [dic objectForKey:@"username"];
    
    [[EaseMob sharedInstance].chatManager rejectBuddyRequest:name reason:nil error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
    
    NSMutableArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:KfriendRequest];
    
    [data removeObject:dic];
    
    //重新存储
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KfriendRequest];
    
    [self loadDataSource];
}


#pragma mark - EaseMob Delegate


#pragma mark - TableVIew DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView tableViewDisplayWithEmptyMsg:@"暂时没有任何消息哦~" ifNecessaryForDataCount:self.dataSource.count];
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"messageCell";
    
    YKApplyRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YKApplyRequestCell" owner:self options:nil] lastObject];
    }
    
    
    NSDictionary *dic = _dataSource[indexPath.row];
    
    cell.name.text = [dic objectForKey:@"username"];
    cell.message.text = [dic objectForKey:@"message"];
    
    cell.acceptButton.tag = indexPath.row;
    cell.rejectButton.tag = indexPath.row;
    
    [cell.acceptButton addTarget:self action:@selector(acceptRequestWithTig:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}


#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - Action
- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Property
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
