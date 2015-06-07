//
//  YKHomeSelectView.m
//  Yinner
//
//  Created by Maru on 15/6/4.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKHomeSelectView.h"

@implementation YKHomeSelectView


#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
    }
    
    return self;
}



#pragma mark - public method
- (void)addChildButtonWithName:(NSString *)name andColor:(UIColor *)color
{
    YKSelectButton *button = [[YKSelectButton alloc] init];
    button.button.imageView.image = [UIImage imageNamed:name];
    button.button.backgroundColor = color;
    button.button.layer.cornerRadius = 35;
    [self adjustAllChildButton];
    [self addSubview:button];
}

#pragma mark - private method
- (void)adjustAllChildButton
{
    NSInteger count = self.subviews.count;
    
    float Width = KwinW / count;
    float height = KwinH;
    
    for (int i = 0; i < count; i++) {
        UIView *view = self.subviews[i];
        view.frame = CGRectMake(Width * i, height, Width, height);
    }
}
@end
