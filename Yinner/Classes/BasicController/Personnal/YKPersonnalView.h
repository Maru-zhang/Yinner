//
//  YKPersonnalView.h
//  Yinner
//
//  Created by Maru on 15/6/19.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKPersonnalViewDelegate <NSObject>
/**
 *    点击粉丝
 */
- (void)personnalFansClick;
/**
 *    点击作品
 */
- (void)personnalWorksClick;
/**
 *    点击设置
 */
- (void)personnalSettingClick;
/**
 *    点击好友
 */
- (void)personnalFriendClick;
/**
 *    点击消息
 */
- (void)personnalMessageClick;
/**
 *    点击主页
 */
- (void)personnalHomeClick;

@end

@interface YKPersonnalView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) id delegate;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *fansNum;
@property (weak, nonatomic) IBOutlet UILabel *worksNum;
@property (weak, nonatomic) IBOutlet UITableView *personnalTable;
@property (weak, nonatomic) IBOutlet UILabel *settingButton;
@property (weak, nonatomic) IBOutlet UILabel *rewardsButton;

@end
