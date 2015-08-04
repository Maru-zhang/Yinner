//
//  YKMoreViewController.m
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKLibraryController.h"
#import "ReuseFrame.h"

@interface YKLibraryController ()
@end

@implementation YKLibraryController

#pragma mark - life cycle

- (instancetype)init
{
    if (self == [super init]) {
        
        //注册接收消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNewDataSource) name:@"database" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRepeatDatabaseWithPath:) name:@"removeRepeat" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setup];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //给tableview添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_libTableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_libTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-kNavH - KstatusH - 44]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_libTableView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_libTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:KstatusH + kNavH]];
}

#pragma mark - public method
- (void)reloadNewDataSource
{
    YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
    
    _mediaArray = [manager queryEntityWithEntityName:@"Media"];
    
    [_libTableView reloadData];
}

#pragma mark - private method
- (void)setup
{

    if (!_libTableView) {
        _libTableView = [[UITableView alloc] init];
        _libTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _libTableView.dataSource = self;
        _libTableView.delegate = self;
        //防止出现偏移
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:_libTableView];

    }
    
    if (!_mediaArray) {
        _mediaArray = [NSArray array];
    }

    //第一次加载的时候也要进行一次查询
    [self reloadNewDataSource];
}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!_mediaArray) {
        return 0;
    }
    
    return _mediaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"libCell";
    
    YKLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YKLibraryCell" owner:nil options:nil] lastObject];
    }
    
    NSManagedObject *entity = _mediaArray[indexPath.row];
    
    cell.title.text = [entity valueForKey:@"name"];
    
    
    return cell;
}

#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *entity = _mediaArray[indexPath.row];
    
    NSString *urlString = [entity valueForKey:@"url"];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL fileURLWithPath:urlString];
    
    YKBrowseViewController *player = [YKBrowseViewController browseViewcontrollerWithUrl:url];
    
    [self presentViewController:player animated:YES completion:nil];
    
    
}

//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObject *entity = _mediaArray[indexPath.row];
        
        YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
        
        //删除本地文件
        NSString *path = [entity valueForKey:@"url"];
        
        NSLog(@"删除的路径:%@",path);
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        [manager deleteDataWithEntity:entity];
        
        [self reloadNewDataSource];
    }
}

//设置左滑的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//删除覆盖掉的数据库
- (void)deleteRepeatDatabaseWithPath:(NSNotification *)notification
{
    NSLog(@"需要覆盖掉的路径为：%@",notification.object);
    for (NSManagedObject *entity in _mediaArray) {
        if ([[entity valueForKey:@"name"] isEqualToString:notification.object]) {
            [[YKCoreDataManager sharedYKCoreDataManager] deleteDataWithEntity:entity];
            [self reloadNewDataSource];
            NSLog(@"删除");
            NSLog(@"时间:%@",[entity valueForKey:@"time"]);
        }
    }
}
@end
