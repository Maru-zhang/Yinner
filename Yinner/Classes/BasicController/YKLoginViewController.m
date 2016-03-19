//
//  YKLoginViewController.m
//  Yinner
//
//  Created by Maru on 15/8/5.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKLoginViewController.h"
#import "ReuseKey.h"
#import "NSString+Valid.h"

@interface YKLoginViewController ()
{
    CGFloat _originWidth;
    CGFloat _originLeftOneX;
    CGFloat _originLeftTwoX;
    CGFloat _originRightOneX;
    CGFloat _originRightTwoX;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *acountInputX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordInputX;

@end

@implementation YKLoginViewController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSetting];
    
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self setupAnimation];
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

- (void)setupView
{
    
    //设置圆角
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.layer.masksToBounds = YES;
    
    //设置原始constant
    _originWidth = self.loginButtonWidth.constant;
    _originLeftOneX = self.accountX.constant;
    _originLeftTwoX = self.passwordX.constant;
    _originRightOneX = self.acountInputX.constant;
    _originRightTwoX = self.passwordInputX.constant;
    
    self.loginButtonWidth.constant = 0;
    self.accountX.constant = -50;
    self.passwordX.constant = - 50;
    self.acountInputX.constant = -300;
    self.passwordInputX.constant = -300;
    
    //设置透明
    self.forgetButton.hidden = YES;
    self.registerButton.hidden = YES;
    
}

- (void)setupAnimation {
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         
                         self.accountX.constant = _originLeftOneX;
                         self.passwordX.constant = _originLeftTwoX;
                         self.acountInputX.constant = _originRightOneX;
                         self.passwordInputX.constant = _originRightTwoX;
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                     }];

    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:1
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         
                         self.loginButtonWidth.constant = _originWidth;

                         self.forgetButton.hidden = NO;
                         self.registerButton.hidden = NO;
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
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

- (void)showAlertViewWithMessage:(NSString *)message {
    
    //弹出提示框
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [alertVC addAction:confirm];
    
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
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
    
    //出现菊花界面
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];

    //有效值判断
    [self judgeValid];
    
    NSString *account = self.account.text;
    NSString *password = self.password.text;
    
    //异步登陆
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:account password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        
        //使菊花界面消失
        [SVProgressHUD dismiss];
        
        if (!error) {
            // 设置自动登陆
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            // 从数据库获取数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            // 获取群组列表
            [[EaseMob sharedInstance].chatManager fetchMyGroupsListWithError:nil];
            // 自动获取好友列表
            [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
            
            // 保存账号密码
            [[NSUserDefaults standardUserDefaults] setObject:account forKey:KuserAccount];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:KuserPassword];
            
            //退出登陆控制器
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            debugLog(@"%@",[[EaseMob sharedInstance].chatManager loginInfo]);
            
        }else if (error.errorCode == EMErrorServerTimeout) {
            [self showAlertViewWithMessage:@"连接超时！"];
        }else if (error.errorCode == EMErrorServerNotReachable) {
            [self showAlertViewWithMessage:@"无法连接至服务器！"];
        }else if (error.errorCode == EMErrorServerAuthenticationFailure) {
            [self showAlertViewWithMessage:@"获取token失败！"];
        }else {
            [self showAlertViewWithMessage:@"出现未知错误！"];
        }
        
    } onQueue:nil];

}

- (IBAction)forgetButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - <UITextFiled Delegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


@end
