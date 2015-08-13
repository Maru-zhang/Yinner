//
//  YKFriendController.m
//  Yinner
//
//  Created by Maru on 15/7/6.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKFriendController.h"
#import "YKChatViewController.h"
#import "YKContactTableViewCell.h"
#import "YKContactModel.h"
#import "YKContactTableViewCell.h"

@interface YKFriendController ()
{
    NSArray *_buddyList;
}

@end

@implementation YKFriendController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSetting];
    
    [self setupView];
    
}


#pragma mark - Private Method
- (void)setupView
{
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
}

- (void)setupSetting
{
    if (!_buddyList) {
        
        //获取好友列表
        [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
            
            _buddyList = [NSArray arrayWithArray:buddyList];
            
        } onQueue:nil];
        
        _buddyList = [[EaseMob sharedInstance].chatManager buddyList];

    }

}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return _buddyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"buddyCell";
    
    YKContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        
        cell = [YKContactTableViewCell contactTableviewCell];
    }
    
    EMBuddy *buddy = _buddyList[indexPath.row];
    
    
    cell.name.text = buddy.username;
    
    
    return cell;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YKContactTableViewCell *cell = (YKContactTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    YKChatViewController *chatVC = [YKChatViewController chatViewControllerWithChatter:cell.name.text conversationType:eConversationTypeChat];
    
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}


@end
