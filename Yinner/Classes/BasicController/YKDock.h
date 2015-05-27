//
//  Dock.h
//  ShopAssistant
//
//  Created by maru on 15-2-1.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKDock : UIView

@property (nonatomic,assign) int selectedIndex;
@property (nonatomic,copy) void (^itemClickBlock)(int index);

-(void)addDockItemWithIcon:(NSString *)name title:(NSString *)title;

@end
