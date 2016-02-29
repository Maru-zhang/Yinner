//
//  YKHomeViewController.m
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKHomeViewController.h"
#import "YKBrowseViewCell.h"
#import "YKBrowseListOperator.h"
#import "YKBrowseVideoModel.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
@interface YKHomeViewController ()
{
    YKHomeSelectView *_seletView;
    UICollectionView *_collectionView;
    UICollectionReusableView *_reuseableView;
    CGSize kItemSize;
}
/** 当前的页码 */
@property (nonatomic,assign) NSNumber *currentPage;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation YKHomeViewController

static NSString *const identifier      = @"browseCell";
static NSString *const reuseIdentifier = @"reuseCell";

#pragma makr - life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //注册两个视图，一个是headView一个是Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"YKBrowseViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
    
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //给——seletView添加约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_seletView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_reuseableView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_seletView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_reuseableView attribute:NSLayoutAttributeHeight multiplier:1 constant:100 - _reuseableView.frame.size.height]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_seletView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_reuseableView attribute:NSLayoutAttributeWidth multiplier:1 constant:-16]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_seletView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_reuseableView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}

- (void)dealloc {
}

#pragma mark - setup
- (void)setupView
{
    
    if (IS_IPHONE_5) {
        kItemSize = CGSizeMake(140, 140);
    }else {
        kItemSize = CGSizeMake(170, 170);
    }
    
    //初始化_seletedView
    _seletView = [[YKHomeSelectView alloc] init];
    _seletView.translatesAutoresizingMaskIntoConstraints = NO;
    _seletView.backgroundColor = [UIColor whiteColor];
    //添加子图标
    [_seletView addChildButtonWithName:@"home_heart.png" andColor:[UIColor colorWithRed:1.000 green:0.400 blue:0.400 alpha:1.000] andTitleName:@"喜爱"];
    [_seletView addChildButtonWithName:@"home_list.png" andColor:[UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000] andTitleName:@"频道"];
    [_seletView addChildButtonWithName:@"home_rank.png" andColor:[UIColor colorWithRed:0.800 green:0.400 blue:1.000 alpha:1.000] andTitleName:@"排行"];
    //调整坐标
    [_seletView adjustAllChildButton];
    
    
    __weak typeof(self) safeSelf = self;
    _seletView.itemClick = ^(int index)
    {
        [safeSelf selectButtonWithTag:index];
        safeSelf.tabBarController.tabBar.hidden = YES;
    };
    
    //设置collectionView的背景颜色
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    //去掉滚动条
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    //添加下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadNewDataWithSetup:YES];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadNewDataWithSetup:NO];
    }];
    
    //加载图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [header setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.collectionView.mj_header = header;
    
    [self.collectionView.mj_header beginRefreshing];
    
}

#pragma mark - Private Method
- (void)loadNewDataWithSetup:(BOOL)setup
{
    
    YKBrowseListOperator *operator = [[YKBrowseListOperator alloc] init];
    
    @weakify(self)
    [operator getWithSuccessHander:^(id responseObject) {
        
        // 如果是初始化那么就清空
        if (setup) {
            [weak_self.dataSource removeAllObjects];
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [weak_self.dataSource addObjectsFromArray:[YKBrowseItem mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
        
        // 刷新表格
        [weak_self.collectionView reloadData];
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [weak_self.collectionView.mj_header endRefreshing];
        [weak_self.collectionView.mj_footer endRefreshing];
    } andFailHander:^(NSError *error) {
        debugLog(@"%@",[error description]);
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [weak_self.collectionView.mj_header endRefreshing];
        [weak_self.collectionView.mj_footer endRefreshing];
    }];
    
}



- (void)selectButtonWithTag:(int)tag
{
    switch (tag) {
        case 0:
            [self performSegueWithIdentifier:@"favourite" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"channel" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"rank" sender:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YKBrowseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    YKBrowseItem *item = self.dataSource[indexPath.row];
    
    cell.browseTitle.text = item.title;
    cell.browseComment.text = [NSString stringWithFormat:@"%ld",(long)item.comment_count];
    cell.browseFavourite.text = [NSString stringWithFormat:@"%ld",(long)item.good_count];
    [cell.browseImage sd_setImageWithURL:[NSURL URLWithString:item.image]];
    
    
    return cell;
}

#pragma mark - delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) {
        _reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        //将_selectedView添加到视图中去
        [_reuseableView addSubview:_seletView];
        
    }
    
    
    return _reuseableView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = (KwinW - 2 * kItemSize.width) / 3;
    return UIEdgeInsetsMake(0, spacing, 44, spacing);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(KwinW, 110);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [NSURL URLWithString:@"http://video2.peiyinxiu.com/2015121223577084db4a830c2df2.mp4"];
    
    YKBrowseViewController *brwoseVC = [[YKBrowseViewController alloc] initWithURL:url];
    
    [self presentViewController:brwoseVC animated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kItemSize;
}

#pragma mark - Property
- (NSNumber *)currentPage {
    if (!_currentPage) {
        _currentPage = [NSNumber numberWithInt:1];
    }
    return _currentPage;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
