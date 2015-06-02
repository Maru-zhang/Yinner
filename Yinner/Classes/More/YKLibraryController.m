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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNewDataSource) name:@"database" object:nil];

    //第一次加载的时候也要进行一次查询
    [self reloadNewDataSource];
}

#pragma mark - datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!_mediaArray) {
        return 0;
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *entity = _mediaArray[indexPath.row];
    
    NSString *urlString = [entity valueForKey:@"url"];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL fileURLWithPath:urlString];
    
    YKWorkViewController *player = [YKWorkViewController WorkViewControllerWithURL:url];
    
    [self presentViewController:player animated:YES completion:nil];
    
    player.watchModel = YES;
    
}

//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObject *entity = _mediaArray[indexPath.row];
        
        YKCoreDataManager *manager = [YKCoreDataManager sharedYKCoreDataManager];
        
        //删除本地文件
        NSString *path = [entity valueForKey:@"url"];
        
        NSLog(@"删除的路径:%@",path);
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        [manager deleteDataWithEntity:entity];
        
        [self reloadNewDataSource];
    }
}

//设置左滑的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
@end
