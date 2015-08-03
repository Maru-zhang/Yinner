//
//  YKPlaySettingController.m
//  Yinner
//
//  Created by Maru on 15/8/4.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKPlaySettingController.h"

@interface YKPlaySettingController ()
{
    NSInteger _currentIndex;
}

@end

@implementation YKPlaySettingController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupSetting];
}

#pragma mark - Private Method
- (void)setupSetting
{
    _currentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"playSetting"];
    
    if (!_currentIndex) {
        _currentIndex = 0;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSLog(@"%ld",_currentIndex);
}

#pragma mark - <Table View Delegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_currentIndex == indexPath.row) {
        return;
    }
    
    UITableViewCell *preCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    
    preCell.accessoryType = UITableViewCellAccessoryNone;
    
    _currentIndex = indexPath.row;
    
    UITableViewCell *curCell = [tableView cellForRowAtIndexPath:indexPath];
    
    curCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"playSetting"];
}

@end
