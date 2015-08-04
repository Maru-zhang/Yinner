//
//  YKBrowseAuthorInfoView.m
//  Yinner
//
//  Created by Maru on 15/8/4.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKBrowseAuthorInfoView.h"

@implementation YKBrowseAuthorInfoView

#pragma mark - Life Cycle


- (void)drawRect:(CGRect)rect
{
    [self setupSetting];
}


#pragma mark - Private Method
- (void)setupSetting
{
    //设置关注按钮
    [_attention addTarget:self action:@selector(attentionClick) forControlEvents:UIControlEventTouchDown];
    [_attention setTitle:@"已关注" forState:UIControlStateSelected];
    
    //设置点赞按钮
    [_goodBtn addTarget:self action:@selector(goodClick) forControlEvents:UIControlEventTouchUpInside];
    [_goodBtn setImage:[UIImage imageNamed:@"good_selected"] forState:UIControlStateSelected];
}





#pragma mark Attention Click
- (void)attentionClick
{
    if (_attention.isSelected) {
        [UIView animateWithDuration:0.5 animations:^{
            _attention.selected = NO;
            _attention.backgroundColor = [UIColor orangeColor];
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _attention.selected = YES;
            _attention.backgroundColor = [UIColor cyanColor];
            [_attention setTintColor:[UIColor orangeColor]];
        }];
        
    }
}

- (void)goodClick
{
    if (_goodBtn.isEnabled) {
        _goodBtn.selected = NO;
    }
    else
    {
        _goodBtn.selected = YES;
    }
}

@end
