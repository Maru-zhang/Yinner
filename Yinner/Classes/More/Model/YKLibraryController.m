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
{
    NSArray *_dataSource;
}
@end

@implementation YKLibraryController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self reloadNewDataSource];
}


#pragma mark - Private Method

- (void)setupSetting {
}

- (void)reloadNewDataSource
{
    YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
    
    _dataSource = [manager queryEntityWithEntityName:@"Media"];
    
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }

    [self.tableView reloadData];
}

#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWithEmptyMsg:@"暂时没有本地的配音哦~" ifNecessaryForDataCount:_dataSource.count];
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"libCell";
    
    YKLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YKLibraryCell" owner:nil options:nil] lastObject];
    }
    
    NSManagedObject *entity = _dataSource[indexPath.row];
    
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
        
        NSManagedObject *obj = [_dataSource objectAtIndex:indexPath.row];

        YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
        
        NSString *url = [obj valueForKey:@"url"];
        
        NSError *error = nil;
        
        [[NSFileManager defaultManager] removeItemAtPath:[MY_MEDIA_DIR_STR stringByAppendingPathComponent:url] error:&error];
        
        if (!error) {
            
            [manager deleteDataWithEntity:obj];
            
            YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
            
            _dataSource = [manager queryEntityWithEntityName:@"Media"];
            
            if (!_dataSource) {
                _dataSource = [NSArray array];
            }
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else {
            debugLog(@"%@",error.description);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *model = _dataSource[indexPath.row];
    
    YKBrowseViewController *vc = [YKBrowseViewController browseViewcontrollerWithUrl:[NSURL fileURLWithPath:[MY_MEDIA_DIR_STR stringByAppendingPathComponent:[model valueForKey:@"url"]]]];
    
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


@end
