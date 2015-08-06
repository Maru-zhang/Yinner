//
//  YKLoginViewController.h
//  Yinner
//
//  Created by Maru on 15/8/5.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;


- (IBAction)registerButton:(id)sender;
- (IBAction)loginButton:(id)sender;

@end
