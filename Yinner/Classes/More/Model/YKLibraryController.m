    //
//  YKLocLibController.m
//  Yinner
//
//  Created by Maru on 15/12/10.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKLibraryController.h"
#import "YKCoreDataManager.h"
#import "YKLibraryCell.h"
#import "UITableView+EmptyData.h"
#import "YKBrowseViewController.h"

@interface YKLibraryController ()

@property (nonatomic,assign) NSArray *dataSource;

@end

@implementation YKLibraryController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSetting];
    
    [self reloadNewDataSource];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"database" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeRepeat" object:nil];
}

#pragma mark - Private Method

- (void)setupSetting {
    //注册接收消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRepeatDatabaseWithPath:) name:@"removeRepeat" object:nil];
}

- (void)reloadNewDataSource
{
    YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
    
    self.dataSource = [manager queryEntityWithEntityName:@"Media"];

    [self.tableView reloadData];
}

//删除覆盖掉的数据库
- (void)deleteRepeatDatabaseWithPath:(NSNotification *)notification
{
    NSLog(@"需要覆盖掉的路径为：%@",notification.object);
    for (NSManagedObject *entity in self.dataSource) {
        if ([[entity valueForKey:@"name"] isEqualToString:notification.object]) {
            [[YKCoreDataManager sharedYKCoreDataManager] deleteDataWithEntity:entity];
            [self reloadNewDataSource];
            NSLog(@"删除");
            NSLog(@"时间:%@",[entity valueForKey:@"time"]);
        }
    }
}

#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithEmptyMsg:@"暂时没有本地的配音哦~" ifNecessaryForDataCount:self.dataSource.count];
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"libCell";
    YKLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YKLibraryCell" owner:nil options:nil] lastObject];
    }
    
    NSManagedObject *entity = self.dataSource[indexPath.row];
    
    cell.title.text = [entity valueForKey:@"name"];
    
    return cell;
}

#pragma mark - TableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
//        NSManagedObject *entity = self.dataSource[indexPath.row];
//        
        YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
        
        [manager queryAllDataBase];
//
//        //删除本地文件
//        NSString *path = [entity valueForKey:@"url"];
//        
//        NSLog(@"删除的路径:%@",path);
//        
//        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//        
//        [manager deleteDataWithEntity:entity];
//        
//        [self reloadNewDataSource];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YKBrowseViewController *vc = [YKBrowseViewController browseViewcontrollerWithUrl:[NSURL URLWithString:[MY_MEDIA_DIR stringByAppendingPathComponent:@"example.mov"]]];
    
    debugLog(@"%@",[NSURL URLWithString:[MY_MEDIA_DIR stringByAppendingPathComponent:@"example.mov"]]);
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - Property
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

@end
