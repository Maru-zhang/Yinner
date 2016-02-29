//
//  YKBrowseController.m
//  Yinner
//
//  Created by Maru on 15/12/19.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKBrowseController.h"
#import "YKBrowseViewCell.h"
#import "YKBrowseLayout.h"
#import <MJRefresh/MJRefresh.h>
#import "YKChannelOperator.h"
#import "YKBrowseVideoModel.h"

@interface YKBrowseController ()
@property (nonatomic,strong) NSMutableArray *dataSource;
@end
@implementation YKBrowseController

#pragma mark - Life Cycyle
- (instancetype)init {
    self = [super initWithCollectionViewLayout:[[YKBrowseLayout alloc] init]];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

#pragma mark - Private Method
- (void)setupView {
    // 标题
    self.title = self.browseTitle;
    // 背景颜色
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    // 注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"YKBrowseViewCell" bundle:nil] forCellWithReuseIdentifier:browseCell];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadData:NO];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadData:(BOOL)setup {
    
    YKChannerType type;
    
    if ([self.title  isEqual: @"喜剧"]) {
        type = YKChannerTypeComedy;
    }else if ([self.title isEqualToString:@"动漫"]) {
        type = YKChannerTypeCartoon;
    }else if ([self.title isEqualToString:@"剧场"]){
        type = YKChannerTypeTheatre;
    }else if ([self.title isEqualToString:@"电视"]) {
        type = YKChannerTypeTV;
    }else if ([self.title isEqualToString:@"方言"]) {
        type = YKChannerTypeLocalism;
    }else if ([self.title isEqualToString:@"解说"]) {
        type = YKChannerTypeComment;
    }
    
    YKChannelOperator *operator = [[YKChannelOperator alloc] init];
    
    @weakify(self)
    [operator getResponseWithType:type SuccessHandler:^(id responseObject) {
        
        if (setup) { [weak_self.dataSource removeAllObjects]; }
        
        [weak_self.dataSource addObjectsFromArray:responseObject];
        
        [weak_self.collectionView reloadData];
        
        [weak_self.collectionView.mj_header endRefreshing];
        [weak_self.collectionView.mj_footer endRefreshing];
        
    } andFailureHandler:^(NSError *error) {
        [weak_self.collectionView.mj_header endRefreshing];
        [weak_self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - Collection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YKBrowseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:browseCell forIndexPath:indexPath];
    YKBrowseItem *item = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.browseTitle.text = item.title;
    cell.browseComment.text = [NSString stringWithFormat:@"%ld",item.comment_count];
    cell.browseFavourite.text = [NSString stringWithFormat:@"%ld",item.good_count];
    [cell.browseImage sd_setImageWithURL:[NSURL URLWithString:item.image]];
    
    return cell;
}

#pragma mark - Property
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
