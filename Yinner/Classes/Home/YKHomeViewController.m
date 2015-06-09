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
    YKHomeSelectView *_seletView;
    UICollectionView *_collectionView;
}
@end

@implementation YKHomeViewController

static NSString *const identifier = @"browseCell";
static NSString *const reuseIdentifier = @"reuseCell";

#pragma makr - life cycle

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(170, 170);
    layout.headerReferenceSize = CGSizeMake(300, 100);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
//    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
//    [self setupView];
    
    NSLog(@"%@",_seletView);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YKBrowseViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    
    //给——seletView添加约束
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_seletView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_seletView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:100 - self.view.frame.size.height]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_seletView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:-10]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_seletView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
//    

}

#pragma mark - setup
- (void)setupView
{
    
    _seletView = [[YKHomeSelectView alloc] init];
    _seletView.translatesAutoresizingMaskIntoConstraints = NO;
    _seletView.backgroundColor = [UIColor whiteColor];
    
    //添加子图标
    [_seletView addChildButtonWithName:@"home_heart.png" andColor:[UIColor colorWithRed:1.000 green:0.400 blue:0.400 alpha:1.000] andTitleName:@"喜爱"];
    [_seletView addChildButtonWithName:@"home_list.png" andColor:[UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000] andTitleName:@"频道"];
    [_seletView addChildButtonWithName:@"home_rank.png" andColor:[UIColor colorWithRed:0.800 green:0.400 blue:1.000 alpha:1.000] andTitleName:@"排行"];
    
    //调整坐标
    [_seletView adjustAllChildButton];
    
    //防止循环引用
    __weak typeof(self) safeSelf = self;
    _seletView.itemClick = ^(int index)
    {
        [safeSelf selectButtonWithTag:index];
    };
    
    [self.view addSubview:_seletView];

}

#pragma mark - private method
- (void)selectButtonWithTag:(int)tag
{
    NSLog(@"点击了:%d",tag);
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
    UICollectionReusableView *view = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        _seletView = [[YKHomeSelectView alloc] initWithFrame:CGRectMake(5, 0, view.frame.size.width - 5, view.frame.size.height)];
        _seletView.translatesAutoresizingMaskIntoConstraints = NO;
        _seletView.backgroundColor = [UIColor whiteColor];
        
        //添加子图标
        [_seletView addChildButtonWithName:@"home_heart.png" andColor:[UIColor colorWithRed:1.000 green:0.400 blue:0.400 alpha:1.000] andTitleName:@"喜爱"];
        [_seletView addChildButtonWithName:@"home_list.png" andColor:[UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000] andTitleName:@"频道"];
        [_seletView addChildButtonWithName:@"home_rank.png" andColor:[UIColor colorWithRed:0.800 green:0.400 blue:1.000 alpha:1.000] andTitleName:@"排行"];
        
        //调整坐标
        [_seletView adjustAllChildButton];
        
        //防止循环引用
        __weak typeof(self) safeSelf = self;
        _seletView.itemClick = ^(int index)
        {
            [safeSelf selectButtonWithTag:index];
        };
        
        [view addSubview:_seletView];
    }
    
//    view.backgroundColor = [UIColor redColor];
    
    return view;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(300, 100);
}

@end
