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

//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    
//    UIView *containerView = transitionContext.containerView;
//    
//    // For a Presentation:
//    //      fromView = The presenting view.
//    //      toView   = The presented view.
//    // For a Dismissal:
//    //      fromView = The presented view.
//    //      toView   = The presenting view.
//    UIView *fromView;
//    UIView *toView;
//    
//    // In iOS 8, the viewForKey: method was introduced to get views that the
//    // animator manipulates.  This method should be preferred over accessing
//    // the view of the fromViewController/toViewController directly.
//    // It may return nil whenever the animator should not touch the view
//    // (based on the presentation style of the incoming view controller).
//    // It may also return a different view for the animator to animate.
//    //
//    // Imagine that you are implementing a presentation similar to form sheet.
//    // In this case you would want to add some shadow or decoration around the
//    // presented view controller's view. The animator will animate the
//    // decoration view instead and the presented view controller's view will
//    // be a child of the decoration view.
//    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
//        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    } else {
//        fromView = fromViewController.view;
//        toView = toViewController.view;
//    }
//    
//    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
//    toView.frame = [transitionContext finalFrameForViewController:toViewController];
//    
//    fromView.alpha = 1.0f;
//    toView.alpha = 1.0f;
//    
//    // We are responsible for adding the incoming view to the containerView
//    // for the presentation/dismissal.
//    [containerView addSubview:toView];
//    
//    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
//    
//    [UIView animateWithDuration:transitionDuration animations:^{
//        fromView.alpha = 0.0f;
//        toView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//        // When we complete, tell the transition context
//        // passing along the BOOL that indicates whether the transition
//        // finished or not.
//        BOOL wasCancelled = [transitionContext transitionWasCancelled];
//        [transitionContext completeTransition:!wasCancelled];
//    }];
//}




@end
