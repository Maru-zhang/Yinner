//
//  YKSearchFriendController.m
//  Yinner
//
//  Created by Maru on 15/8/11.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKSearchFriendController.h"

@interface YKSearchFriendController ()
{
    NSMutableArray *_dataSource;
}

@end

@implementation YKSearchFriendController


#pragma mark - Life Cycyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)setupSetting
{
    //对数据源进行懒加载
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}



- (IBAction)searchClick:(id)sender {
    if (!self.searchBar.text) {
        return;
    }
    
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:self.searchBar.text message:nil error:&error];
    
    if (isSuccess) {
        NSLog(@"成功添加好友！");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加请求已发送！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:confirm];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else
    {
        NSLog(@"添加好友失败！");
    }
    
    
}
@end
