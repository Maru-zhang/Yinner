//
//  YKMoreViewController.m
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKLibraryController.h"
#import "ReuseFrame.h"

@interface YKLibraryController ()

@end

@implementation YKLibraryController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];

}


#pragma mark - private method
- (void)setup
{
    if (!_libTableView) {
        _libTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH + KstatusH, KwinW, KwinH - kNavH - KstatusH)];
        _libTableView.dataSource = self;
        _libTableView.delegate = self;
        [self.view addSubview:_libTableView];
    }
    
    if (!_mediaArray) {
        _mediaArray = [NSMutableArray array];
    }

}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"libCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"哈哈哈哈";
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
