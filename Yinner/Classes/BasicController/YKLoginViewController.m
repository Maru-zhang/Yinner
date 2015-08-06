//
//  YKLoginViewController.m
//  Yinner
//
//  Created by Maru on 15/8/5.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKLoginViewController.h"
#import "ReuseKey.h"
#import "YKMainViewController.h"
#import "NSString+Valid.h"

@interface YKLoginViewController ()

@end

@implementation YKLoginViewController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private Method 
- (void)setupSetting
{
    self.account.delegate = self;
    self.account.delegate = self;
    
    //看看本地中是否存在用户账号和密码
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:KuserAccount];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KuserPassword];
    
    if (account) {
        self.account.text = account;
        self.password.text = password;
    }
}

- (void)judgeValid
{
    //判断中文字符
    if ([self.account.text isChinese]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名不能包含中文！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:confirm];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        return;
    }
    
    if (self.account.text.length == 0 || self.password.text.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名和密码不能为空！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:confirm];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
        return;
    }
}



#pragma mark - Action
- (IBAction)registerButton:(id)sender {
    
    //有效值判断
    [self judgeValid];
    
    NSString *account = self.account.text;
    NSString *password = self.password.text;
    
    
    
    //异步注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:account password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"恭喜您，注册成功！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            UIAlertAction *login = [UIAlertAction actionWithTitle:@"现在登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [alert addAction:cancel];
            [alert addAction:login];
            
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:account forKey:KuserAccount];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:KuserPassword];
        
    } onQueue:nil];
    
}

- (IBAction)loginButton:(id)sender {
    
    //有效值判断
    [self judgeValid];
    
    NSString *account = self.account.text;
    NSString *password = self.password.text;
    
    //异步登陆
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:account password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (!error) {
            NSLog(@"登陆成功！");
            
            //设置自动登陆
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            //从数据库获取数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            //获取群组列表
            [[EaseMob sharedInstance].chatManager fetchMyGroupsListWithError:nil];
            //自动获取好友列表
            [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
            
            
            //退出登陆控制器
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    } onQueue:nil];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:KuserAccount];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:KuserPassword];
}


#pragma mark - <UITextFiled Delegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

@end
