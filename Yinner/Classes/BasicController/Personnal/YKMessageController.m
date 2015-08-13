//
//  YKMessageController.m
//  Yinner
//
//  Created by Maru on 15/7/6.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKMessageController.h"

@interface YKMessageController ()
{
    NSMutableArray *_dataSource;
}

@end

@implementation YKMessageController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    [self setupSetting];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
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
}


#pragma mark - EaseMob Delegate
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSDictionary *dic = [NSDictionary dictionary];
    
    [dic setValue:username forKey:@"name"];
    [dic setValue:message forKey:@"message"];
    
    [array addObject:dic];
    
    _dataSource = array;
    
    [self.tableView reloadData];
    
    NSLog(@"好友请求来自%@",username);
}

#pragma mark - TableVIew Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataSource) {
        return _dataSource.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"messageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    
    NSDictionary *dic = _dataSource[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"来自%@的好友请求！",[dic objectForKey:@"name"]];
    
    return cell;
}

@end
