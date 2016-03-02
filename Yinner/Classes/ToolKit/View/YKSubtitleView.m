
//
//  YKSubtitleView.m
//  Yinner
//
//  Created by Maru on 15/12/16.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKSubtitleView.h"


#define kHighLight_C [UIColor whiteColor]
#define kNormal_C [UIColor lightGrayColor]
#define kOffsetValue 30.0f

@interface YKSubtitleView ()
{
    CAShapeLayer *_leftLine;
    CAShapeLayer *_rightLine;
}
@property (nonatomic,assign) NSInteger currentLine;
@end

@implementation YKSubtitleView

- (instancetype)init {
    if (self = [super init]) {
        
        
        // 初始化线条
        _leftLine = [CAShapeLayer layer];
        
        [_leftLine setStrokeColor:[UIColor whiteColor].CGColor];
        [_leftLine setLineWidth:2.0f];
        [_leftLine setFillColor:[UIColor clearColor].CGColor];
        
        _rightLine = [CAShapeLayer layer];
        
        [_rightLine setStrokeColor:[UIColor whiteColor].CGColor];
        [_rightLine setLineWidth:2.0f];
        [_rightLine setFillColor:[UIColor clearColor].CGColor];
        

    }
    return self;
}



#pragma mark - 重写
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    
    // 移除线条
    [_rightLine removeFromSuperlayer];
    [_leftLine removeFromSuperlayer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UITableViewCell *pre_cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLine inSection:0]];
        pre_cell.textLabel.textColor = kNormal_C;
        
        UITableViewCell *cur_cell =  [self cellForRowAtIndexPath:indexPath];
        cur_cell.textLabel.textColor = kHighLight_C;
        
        self.currentLine = indexPath.row;
    });
    
    [super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    
    // 设置线条参数
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    CGRect textRect = [cell.textLabel.text boundingRectWithSize:cell.textLabel.bounds.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil];
    
    _leftLine.frame = cell.bounds;
    _leftLine.position = CGPointMake(CGRectGetWidth(cell.bounds) / 2, CGRectGetHeight(cell.bounds) / 2);
    
    // 创建路径
    CGMutablePathRef firstLine = CGPathCreateMutable();
    CGMutablePathRef secondLine = CGPathCreateMutable();
    
    CGPathMoveToPoint(firstLine, NULL, 0, CGRectGetHeight(cell.frame) / 2);
    CGPathAddLineToPoint(firstLine, NULL, CGRectGetWidth(cell.frame) / 2 - CGRectGetWidth(textRect) / 2 - kOffsetValue, CGRectGetHeight(cell.frame) / 2);
    
    CGPathMoveToPoint(secondLine, NULL, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame) / 2);
    CGPathAddLineToPoint(secondLine, NULL, CGRectGetWidth(cell.frame) / 2 + CGRectGetWidth(textRect) / 2 + kOffsetValue, CGRectGetHeight(cell.frame) / 2);
    
    [_leftLine setPath:firstLine];
    [_rightLine setPath:secondLine];
    
    [cell.layer addSublayer:_leftLine];
    [cell.layer addSublayer:_rightLine];

    CABasicAnimation *annimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    annimation.fromValue = @0;
    annimation.toValue = @1;
    annimation.duration = 2.0;
    
    [_leftLine addAnimation:annimation forKey:nil];
    [_rightLine addAnimation:annimation forKey:nil];
    
}

#pragma mark - Property
- (NSInteger)currentLine {
    if (!_currentLine) {
        _currentLine = 0;
    }
    return _currentLine;
}

@end
