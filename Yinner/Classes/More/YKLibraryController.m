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

#pragma mark - public method
- (void)reloadNewDataSource
{
    YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
    
    _mediaArray = [manager queryEntityWithEntityName:@"Media"];
    
    [_libTableView reloadData];
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
        _mediaArray = [NSArray array];
    }
    
    //添加接收消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNewDataSource) name:@"saveover" object:nil];

    //第一次加载的时候也要进行一次查询
    [self reloadNewDataSource];
}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mediaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"libCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSManagedObject *entity = _mediaArray[indexPath.row];
    
    cell.textLabel.text = [entity valueForKey:@"name"];
    
    
    return cell;
}

#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
