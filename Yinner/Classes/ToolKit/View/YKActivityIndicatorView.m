//
//  YKActivityIndicatorView.m
//  Yinner
//
//  Created by Maru on 15/8/20.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKActivityIndicatorView.h"

@interface YKActivityIndicatorView ()
{
    UIView *_backView;
    UIView *_maskView;
    UIActivityIndicatorView *_indicator;
}
@end

@implementation YKActivityIndicatorView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupView];
        
    }
    
    return self;
}

#pragma mark - Private Method
- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    
    //创建遮罩
    _maskView = [[UIView alloc] initWithFrame:self.frame];
    _maskView.backgroundColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    _maskView.alpha = 0.5;
    
    [self addSubview:_maskView];

    //添加背景视图
    _backView = [[UIView alloc] init];
    
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.8;
    _backView.bounds = CGRectMake(0, 0, 100, 80);
    [_backView.layer setCornerRadius:10];
    _backView.center = self.center;
    
    [self addSubview:_backView];
    
    //配置菊花
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    _indicator.center = CGPointMake(50, 40);
    
    [_backView addSubview:_indicator];
    
    [_indicator startAnimating];
    
}

@end
