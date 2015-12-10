//
//  Dock.m
//  ShopAssistant
//
//  Created by maru on 15-2-1.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKDock.h"
#import "YKDockItem.h"
#import "NSString+File.h"

#define KWinW [UIScreen mainScreen].bounds.size.width

@interface YKDock()
{
    YKDockItem *_currentItem;
}
@end
@implementation YKDock


//init方法内部会调用这个方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
        self.alpha = 1;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


-(void)addDockItemWithIcon:(NSString *)name title:(NSString *)title
{
    YKDockItem *dockItem = [[YKDockItem alloc] init];
    
    if ([title isEqualToString:@""]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dockItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        return;
    }
    
    [self addSubview:dockItem];
    
    //设置item的文字
    [dockItem setTitle:title forState:UIControlStateNormal];

    //设置item的图片
    [dockItem setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [dockItem setImage:[UIImage imageNamed:[name fileNameAppend:@"_selected"]] forState:UIControlStateSelected];
    
    //添加item的监听方法
    [dockItem addTarget:self action:@selector(dockItemClick:) forControlEvents:UIControlEventTouchDown];
    
    //调整
    [self adjustDockItemPosition];
}

#pragma mark - 调整每一个item的位置
-(void)adjustDockItemPosition
{
    int count = (int)self.subviews.count;
    
    UIButton *item;
    
    CGFloat itemWidth = KWinW / count;
    CGFloat itemHigh = self.frame.size.height;
    
    for (int i = 0; i < count; i++) {
        
        item = self.subviews[i];
        
        item.frame = CGRectMake(itemWidth * i, 0, itemWidth, itemHigh);
        
        item.tag = i;
        
    }
    
    //设置初始的点击位置
    self.selectedIndex = 0;
}

#pragma mark - DockItem点击事件
-(void)dockItemClick:(YKDockItem *)dockItem
{
    _currentItem.selected = NO;
    
    _currentItem = dockItem;
    
    _currentItem.selected = YES;
    
    if (_itemClickBlock) {
        _itemClickBlock((int)dockItem.tag);
    }
}

#pragma mark - 重写selectedIndex的set方法
-(void)setSelectedIndex:(int)selectedIndex
{
    //过滤条件
    if (selectedIndex < 0 || selectedIndex >= self.subviews.count) {
        return;
    }
    
    YKDockItem *item = self.subviews[selectedIndex];
    
    _currentItem = item;
    
    [self dockItemClick:_currentItem];
}

@end
