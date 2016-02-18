//
//  YKMessageSettingController.m
//  Yinner
//
//  Created by Maru on 15/8/4.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKMessageSettingController.h"
#import "YKUserSetting.h"

@interface YKMessageSettingController ()
@property (weak, nonatomic) IBOutlet UISwitch *messagePushSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *privateMessageSwitch;

@end

@implementation YKMessageSettingController

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
- (void)setupSetting {
    
    BOOL pushResult = [YKUserSetting getAllowMessagePush];
    BOOL privatereslt = [YKUserSetting getAllowPrivateMessage];
    
    pushResult ? [self.messagePushSwitch setOn:YES] : [self.messagePushSwitch setOn:NO];
    privatereslt ? [self.privateMessageSwitch setOn:YES] : [self.privateMessageSwitch setOn:NO];
    
    [self.messagePushSwitch addTarget:self action:@selector(messagePushClick) forControlEvents:UIControlEventTouchUpInside];
    [self.privateMessageSwitch addTarget:self action:@selector(privateMsgClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)messagePushClick {
    if (self.messagePushSwitch.on) {
        [YKUserSetting setAllowMessagePush:YES];
    }else {
        [YKUserSetting setAllowMessagePush:NO];
    }
}

- (void)privateMsgClick {
    if (self.privateMessageSwitch.on) {
        [YKUserSetting setAllowPrivateMessage:YES];
    }else {
        [YKUserSetting setAllowPrivateMessage:NO];
    }
}


- (IBAction)pushClick:(id)sender {
    if (self.messagePushSwitch.on) {
        [YKUserSetting setAllowMessagePush:YES];
    }else {
        [YKUserSetting setAllowMessagePush:NO];
    }
}
- (IBAction)privateClick:(id)sender {
    if (self.privateMessageSwitch.on) {
        [YKUserSetting setAllowPrivateMessage:YES];
    }else {
        [YKUserSetting setAllowPrivateMessage:NO];
    }
}

@end
