//
//  YKHomeViewController.h
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReuseFrame.h"
#import "YKHomeSelectView.h"
#import "YKBrowseViewController.h"

@protocol YKHomeControllerDelegate <NSObject>

- (void)homeControllerItemClickAtIndex:(int)index;

@end

@interface YKHomeViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) id<YKHomeControllerDelegate> delegate;

@end
