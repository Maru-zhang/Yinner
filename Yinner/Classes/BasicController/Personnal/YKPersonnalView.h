//
//  YKPersonnalView.h
//  Yinner
//
//  Created by Maru on 15/6/19.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKPersonnalViewDelegate <NSObject>

- (void)personnalSettingClick;
- (void)personnalFriendClick;
- (void)personnalMessageClick;
- (void)personnalHomeClick;

@end

@interface YKPersonnalView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) id delegate;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *fansNum;
@property (weak, nonatomic) IBOutlet UILabel *worksNum;
@property (weak, nonatomic) IBOutlet UITableView *personnalTable;
@property (weak, nonatomic) IBOutlet UILabel *settingButton;

@end
