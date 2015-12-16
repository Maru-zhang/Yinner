//
//  UIView+GrayLine.m
//  Yinner
//
//  Created by Maru on 15/12/14.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "UIView+GrayLine.h"

@implementation UIView (GrayLine)

+ (UIView *)getGrayLine {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

@end
