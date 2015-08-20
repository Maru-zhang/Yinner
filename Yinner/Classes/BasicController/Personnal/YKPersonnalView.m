//
//  YKPersonnalView.m
//  Yinner
//
//  Created by Maru on 15/6/19.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKPersonnalView.h"
#import "YKPersonnalCell.h"
#import "YKLoginViewController.h"

@interface YKPersonnalView ()
{
    NSArray *_dataSource;
}
@end

@implementation YKPersonnalView

#pragma makr - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSetting];
}

#pragma makr - Private Method
- (void)setupSetting
{
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 50;
    
    self.personnalTable.delegate = self;
    self.personnalTable.dataSource = self;
//    self.personnalTable.allowsSelection = NO;
    //给每一个按钮设置手势监听事件
    
    UITapGestureRecognizer *tapSetting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingButtonClick)];
    self.settingButton.userInteractionEnabled = YES;
    [self.settingButton addGestureRecognizer:tapSetting];
    
    
    UITapGestureRecognizer *tapRewards = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rewardsButtonClick)];
    self.rewardsButton.userInteractionEnabled = YES;
    [self.rewardsButton addGestureRecognizer:tapRewards];
    
    
    if (!_dataSource) {
        _dataSource = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"PersonnalPlist" withExtension:@"plist"]];
    }
}


#pragma mark - Private Method
- (void)rewardsButtonClick
{

}


- (void)settingButtonClick
{
    if ([_delegate respondsToSelector:@selector(personnalSettingClick)]) {
        [_delegate personnalSettingClick];
    }
}

- (void)friendButtonClick
{
    if ([_delegate respondsToSelector:@selector(personnalFriendClick)]) {
        [_delegate personnalFriendClick];
    }
}

- (void)messageButtonClick
{
    if ([_delegate respondsToSelector:@selector(personnalMessageClick)]) {
        [_delegate personnalMessageClick];
    }
}

- (void)homeButtonClick
{
    if ([_delegate respondsToSelector:@selector(personnalHomeClick)]) {
        [_delegate personnalHomeClick];
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"personnalCell";
    
    YKPersonnalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YKPersonnalCell" owner:self options:nil] lastObject];
    }
    
    
    cell.cellTitle.text = [_dataSource[indexPath.row] objectForKey:@"title"];
    NSString *imageName = [_dataSource[indexPath.row] objectForKey:@"image"];
    cell.cellImage.image = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self homeButtonClick];
            break;
        case 1:
            [self friendButtonClick];
            break;
        case 2:
            [self messageButtonClick];
            break;
        default:
            break;
    }
}
@end
