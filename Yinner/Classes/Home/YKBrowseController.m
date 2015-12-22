//
//  YKBrowseController.m
//  Yinner
//
//  Created by Maru on 15/12/19.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKBrowseController.h"
#import "YKBrowseViewCell.h"
// 列数
static const int columNum = 2;
// 列间距
static const CGFloat spacing = 20.0;
@interface YKBrowseController ()
/** Cell大小 */
@property (nonatomic,assign,readonly) CGSize itemSize;
@end
@implementation YKBrowseController

#pragma mark - Life Cycyle
- (instancetype)init {
    self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

#pragma mark - Private Method
- (void)setupView {
    // 背景颜色
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    // 注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"YKBrowseViewCell" bundle:nil] forCellWithReuseIdentifier:browseCell];
}

#pragma mark - Collection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:browseCell forIndexPath:indexPath];
    return cell;
}

#pragma mark - Collection Delegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(spacing, spacing, 0, spacing);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemSize;
}

#pragma mark - Property
- (CGSize)itemSize {
    CGFloat sideL = (SCREEN_WIDTH - (columNum + 1) * spacing) / columNum;
    return CGSizeMake(sideL, sideL);
}

@end
