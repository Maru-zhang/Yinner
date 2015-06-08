//
//  YKHomeSelectView.h
//  Yinner
//
//  Created by Maru on 15/6/4.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKSelectButton.h"
#import "ReuseFrame.h"
@interface YKHomeSelectView : UIView

@property (nonatomic,copy) void(^itemClick)(int index);

- (void)adjustAllChildButton;
- (void)addChildButtonWithName:(NSString *)name andColor:(UIColor *)color andTitleName:(NSString *)titlename;

@end
