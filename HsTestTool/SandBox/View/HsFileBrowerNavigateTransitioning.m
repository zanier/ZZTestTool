//
//  HsFileBrowerNavigateTransitioning.m
//  HsTestTool
//
//  Created by zanier on 2020/7/4.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "HsFileBrowerNavigateTransitioning.h"

@implementation HsFileBrowerNavigateTransitioning

- (instancetype)initWithSourceView:(UIView *)sourceView isPresented:(BOOL)isPresented {
    if (self = [super init]) {
        _sourceView = sourceView;
        _isPresented = isPresented;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
//    return;
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    NSTimeInterval duration = [self transitionDuration:nil];
    
    if (1 || _isPresented) {
        /// push
        /// tempView
        UIView *tempView = [_sourceView snapshotViewAfterScreenUpdates:YES];
        /// add subviews
        [containerView addSubview:toVC.view];
        [containerView addSubview:tempView];
        /// hide from imageView
//        toView.hidden = YES;
//        fromView.hidden = YES;
        /// animation
        [UIView animateWithDuration:duration animations:^{
            ///
            tempView.frame = tempView.frame;
        } completion:^(BOOL finished) {
            if (finished) {
            }
//            toView.hidden = NO;
//            fromView.hidden = NO;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        // pop
        [UIView animateWithDuration:duration animations:^{
            
        }];
    }
    
}

@end
