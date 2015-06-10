//
//  MainViewController.h
//  Yinner
//
//  Created by Maru on 15/5/26.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKDock.h"
#import "YKHomeViewController.h"
#import "YKPlayViewController.h"
#import "YKLibraryController.h"

@interface YKMainViewController : UIViewController <UINavigationBarDelegate,YKHomeControllerDelegate>

@property (nonatomic,assign) int currentIndex;
@property (weak, nonatomic) IBOutlet YKDock *dock;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
