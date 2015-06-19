//
//  YKPersonnalView.m
//  Yinner
//
//  Created by Maru on 15/6/19.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKPersonnalView.h"
#import "YKPersonnalCell.h"

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
    
    if (!_dataSource) {
        _dataSource = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"PersonnalPlist" withExtension:@"plist"]];
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
    NSLog(@"点击了%ld",indexPath.row);
}
@end
