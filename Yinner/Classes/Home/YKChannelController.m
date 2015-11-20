//
//  YKChannelController.m
//  Yinner
//
//  Created by Maru on 15/6/11.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKChannelController.h"
#import "YKChannelViewCell.h"
#import "ReuseFrame.h"

@interface YKChannelController ()
{
    NSArray *_dataSource;
    UICollectionViewFlowLayout *_layout;
}
@end

@implementation YKChannelController

static NSString * const reuseIdentifier = @"channelCell";

#pragma mark - Life cycle
- (instancetype)init
{
    NSLog(@"dsadsadsadsa");
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(145, 98);
    return [self initWithCollectionViewLayout:_layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YKChannelViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    //进行基本设置
    [self setupSetting];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Method
- (void)setupSetting
{
    if (_dataSource == nil) {
        _dataSource = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ChannelPlist" withExtension:@"plist"]];
    }


}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YKChannelViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.cellTitle.text = [_dataSource[indexPath.row] objectForKey:@"title"];
    cell.bgImage.image = [UIImage imageNamed:[_dataSource[indexPath.row] objectForKey:@"image"]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    //计算边距，设置边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;

    CGFloat spacing = (CGFloat)(KwinW - layout.itemSize.width * 2) / 3;
    
    return UIEdgeInsetsMake(spacing, spacing, 44, spacing);
}

@end
