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
- (void)addChildButtonWithName:(NSString *)name andColor:(UIColor *)color andTitleName:(NSString *)titlename
{
    NSArray *buttonArray = [[NSBundle mainBundle] loadNibNamed:@"YKSelectButton" owner:self options:nil];
    
    YKSelectButton *button = [buttonArray lastObject];
    //赋值图片
    [button.button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    //赋值文字
    [button.title setText:titlename];
    //赋值颜色
    button.button.backgroundColor = color;
    //设置圆形
    button.button.layer.cornerRadius = 30;
    [self addSubview:button];
    
}

- (void)adjustAllChildButton
{
    NSInteger count = self.subviews.count;
    
    float Width = KwinW / count;
    float height = 100;
    
    for (int i = 0; i < count; i++) {
        UIView *view = self.subviews[i];
        view.frame = CGRectMake(Width * i, 0, Width, height);
    }
}
@end
