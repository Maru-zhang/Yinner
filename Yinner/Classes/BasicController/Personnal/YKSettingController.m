//
//  YKSettingControllerTableViewController.m
//  Yinner
//
//  Created by Maru on 15/7/6.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKSettingController.h"
#import "YKLoginViewController.h"
#import "YKPersonInfoController.h"

@interface YKSettingController ()
@end

@implementation YKSettingController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillLayoutSubviews {
    
    UITableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UILabel *name = cell1.contentView.subviews[1];
    UILabel *account = cell1.contentView.subviews[2];
    
    // 判断当前是否有用户登录
    if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
        
        name.text = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
        account.text = [NSString stringWithFormat:@"账号:%@",[[EaseMob sharedInstance].chatManager loginInfo][@"username"]];
    }else {
        name.text = @"请登录后查看";
        account.text = @"";
    }
    
//    debugLog(@"%@",[[EaseMob sharedInstance].chatManager loginInfo]);
}


#pragma mark - Table view data source


#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
            
            YKPersonInfoController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"YKPersonInfoController"];
            
            [self.navigationController pushViewController:VC animated:YES];
        }else {
            
            [self performSegueWithIdentifier:@"exit-login" sender:self];
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 2) {
            
            [SVProgressHUD showSuccessWithStatus:@"请前往App Store支持我们！" maskType:SVProgressHUDMaskTypeGradient];
        }else if (indexPath.row == 4) {
            
            NSError *error;
            
            NSArray *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:ORIGIN_MEDIA_DIR_STR error:&error];
            
            // 开始遍历删除
            for (NSString *item in items) {
                [[NSFileManager defaultManager] removeItemAtPath:[ORIGIN_MEDIA_DIR_STR stringByAppendingPathComponent:item] error:nil];
            }
            
            // UI显示
            if (error == nil) {
                [SVProgressHUD showSuccessWithStatus:@"缓存清理成功！" maskType:SVProgressHUDMaskTypeGradient];
            }else {
                [SVProgressHUD showErrorWithStatus:@"出现未知错误" maskType:SVProgressHUDMaskTypeGradient];
            }
            
            debugLog(@"%@",items);

        }

        
    }else if (indexPath.section == 2) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否确定退出！" preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        //确定退出操作
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [SVProgressHUD showWithStatus:@"正在注销..." maskType:SVProgressHUDMaskTypeBlack];
            
            //退出登陆
            [[[EaseMob sharedInstance]chatManager] asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                
                [SVProgressHUD dismiss];
                
                [self performSegueWithIdentifier:@"exit-login" sender:self];
                
                
            } onQueue:nil];
            
        }];
        
        //取消操作
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            return;
        }];
        
        
        [alert addAction:confirm];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
}
#pragma mark - Action
- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
