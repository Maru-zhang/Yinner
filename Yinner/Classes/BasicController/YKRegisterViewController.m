//
//  YKRegisterViewController.m
//  Yinner
//
//  Created by Maru on 16/4/23.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKRegisterViewController.h"
#import "NSString+Valid.h"

@interface YKRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation YKRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRegisterKeyboard)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissRegisterKeyboard {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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



- (IBAction)registerAction:(id)sender {
    
    //有效值判断
    [self judgeValid];
    
    NSString *account = self.account.text;
    NSString *password = self.password.text;
    
    //异步注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:account password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            debugLog(@"注册成功");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"恭喜您，注册成功！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:true completion:nil];
            }];

            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }else {
            
            [SVProgressHUD showErrorWithStatus:error.description];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:account forKey:KuserAccount];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:KuserPassword];
        
    } onQueue:nil];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
