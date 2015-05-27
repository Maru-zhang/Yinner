//
//  DockItem.m
//  ShopAssistant
//
//  Created by maru on 15-2-1.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#define kImageRadio 0.6

#import "YKDockItem.h"

@implementation YKDockItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置文字的各项属性
        /*
         设置UIButton的字体颜色的时候，使用UIButton.labletext.textcolor属性设置颜色是不能成功的！！！！！
         */
        self.titleLabel.textAlignment =  NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12.];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        
        //设置图片
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted = NO;
        
    }
    
    return self;
}

#pragma mark - 重写父类的高亮方法
-(void)setHighlighted:(BOOL)highlighted {}

#pragma mark - 返回title的边框位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * kImageRadio;
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, self.frame.size.width, titleH);
}


#pragma mark - 返回image的边框位置
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 3, contentRect.size.width, contentRect.size.height * kImageRadio);
}

#pragma mark - 重写backColor
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}
@end
