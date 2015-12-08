//
//  YKHomeViewController.m
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKHomeViewController.h"
#import "YKBrowseViewCell.h"

@interface YKHomeViewController ()
{
    UICollectionViewFlowLayout *_layout;
    YKHomeSelectView *_seletView;
    UICollectionView *_collectionView;
    UICollectionReusableView *_reuseableView;
}
@end

@implementation YKHomeViewController

static NSString *const identifier = @"browseCell";
static NSString *const reuseIdentifier = @"reuseCell";

#pragma makr - life cycle
- (instancetype)init
{
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(170, 170);
    _layout.headerReferenceSize = CGSizeMake(KwinW, 100);
    return [self initWithCollectionViewLayout:_layout];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //注册两个视图，一个是headView一个是Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"YKBrowseViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
    
    [self setupView];
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

#pragma mark - setup
- (void)setupView
{
    
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
    };
    
    //设置collectionView的背景颜色
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    //去掉滚动条
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    //添加下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadNewData];
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
    
    self.collectionView.header = header;
    
    [self.collectionView.header beginRefreshing];
    
}

#pragma mark - private method

- (void)loadNewData
{
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.collectionView reloadData];
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [self.collectionView.header endRefreshing];
    });
}



- (void)selectButtonWithTag:(int)tag
{
    if ([_delegate respondsToSelector:@selector(homeControllerItemClickAtIndex:)]) {
        [_delegate homeControllerItemClickAtIndex:tag];
    }
}

#pragma mark - dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YKBrowseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
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
    
    CGFloat cellWidth = _layout.itemSize.width;
    CGFloat spacing = (KwinW - 2 * cellWidth) / 3;
    return UIEdgeInsetsMake(0, spacing, 44, spacing);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(KwinW, 110);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"mov"];
    
    YKBrowseViewController *browseVC = [YKBrowseViewController browseViewcontrollerWithUrl:url];
    
    [self presentViewController:browseVC animated:YES completion:nil];
}

@end
