//
//  YKTranstaionAnimator.m
//  Yinner
//
//  Created by Maru on 16/3/21.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKTranstaionAnimator.h"

@implementation YKTranstaionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *fromView;
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];

    [containerView addSubview:toView];

    // Make mask Path
    CGPathRef beginPath;
    CGPathRef endPath;
    if ([fromViewController isKindOfClass:[UITabBarController class]]) {
        beginPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(fromView.frame) / 2, fromView.frame.size.height - 10) radius:20 startAngle:0 endAngle:2 * M_PI clockwise:NO].CGPath;
        endPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(fromView.frame) / 2, fromView.frame.size.height - 10) radius:fromView.frame.size.height * 1.5 startAngle:0 endAngle:2 * M_PI clockwise:NO].CGPath;
        
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = endPath;
        toView.layer.mask = mask;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.fromValue = (__bridge id _Nullable)beginPath;
        animation.toValue = (__bridge id _Nullable)endPath;
        animation.duration = [self transitionDuration:transitionContext];
        animation.autoreverses = NO;
        animation.repeatCount = 1;
        [mask addAnimation:animation forKey:@"path"];
    }else {
        beginPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(fromView.frame) / 2, fromView.frame.size.height) radius:fromView.frame.size.height * 1.5 startAngle:0 endAngle:2 * M_PI clockwise:NO].CGPath;
        endPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(fromView.frame) / 2, fromView.frame.size.height) radius:20 startAngle:0 endAngle:2 * M_PI clockwise:NO].CGPath;
        
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = endPath;
        toView.layer.mask = mask;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.fromValue = (__bridge id _Nullable)beginPath;
        animation.toValue = (__bridge id _Nullable)endPath;
        animation.duration = [self transitionDuration:transitionContext];
        animation.autoreverses = NO;
        animation.repeatCount = 1;
        [mask addAnimation:animation forKey:@"path"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self transitionDuration:transitionContext] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    });
    
    
    
    
}

@end
