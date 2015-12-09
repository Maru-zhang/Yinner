//
//  YKPlayViewController.m
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKPlayViewController.h"

@interface YKPlayViewController ()
{
    NSArray *_dataSource;
}
@end

@implementation YKPlayViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    
    [self setupSetting];
    
}

#pragma mark - Private Method
- (void)setupSetting
{
    if (!_dataSource) {
        
        NSURL *dataURL = [[NSBundle mainBundle] URLForResource:@"MatterSort" withExtension:@"plist"];
        
        _dataSource = [NSArray arrayWithContentsOfURL:dataURL];
    }
}



#pragma mark - dataSource
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
    static NSString *identifier = @"playCell";

    YKPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"YKPlayTableViewCell" owner:self options:nil];
        
        cell = [cellArray lastObject];
        
    }
    
    NSDictionary *dic = _dataSource[indexPath.row];
    
    cell.title.text = [dic objectForKey:@"name"];
    cell.headImage.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    
    return cell;
}


#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"location" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - Action
- (IBAction)closeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
