//
//  TKSuggestSettingController.m
//  Yinner
//
//  Created by Maru on 15/8/4.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "TKSuggestSettingController.h"

@interface TKSuggestSettingController ()
@property (weak, nonatomic) IBOutlet UITextField *suggestionContent;
@end

@implementation TKSuggestSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Action
- (IBAction)submitClick:(id)sender {
    
    // 检查信息正确性
    if ([self.suggestionContent.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"反馈信息不得为空哦，亲！" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }

    // 进行提交反馈操作
    [SVProgressHUD showSuccessWithStatus:@"已经成功提交反馈，谢谢您的支持与期待！" maskType:SVProgressHUDMaskTypeGradient];
    
}



@end
