//
//  YKMoreViewController.h
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKCoreDataManager.h"

@interface YKLibraryController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *mediaArray;
@property (nonatomic,strong) UITableView *libTableView;

- (void)reloadNewDataSource;

@end
