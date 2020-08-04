//
//  ZZFileBrowerAnimatedTransitioning.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/30.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZFileBrowerAnimatedTransitioning.h"

@implementation ZZFileBrowerAnimatedTransitioning

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
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    NSTimeInterval duration = [self transitionDuration:nil];
    
    if (1 || _isPresented) {
        /// tempView
        UIView *tempView = [_sourceView snapshotViewAfterScreenUpdates:YES];
        /// blurEffectView
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        blurEffectView.frame = UIScreen.mainScreen.bounds;
        [tempView addSubview:blurEffectView];
//        /// toVC
//        toVC.view.hidden = YES;
        /// add subviews
        [containerView addSubview:tempView];
        [containerView addSubview:toVC.view];
//        /// hide from imageView
//        fromView.hidden = YES;
        blurEffectView.alpha = 0.0f;

        /// animation
        [UIView animateWithDuration:duration animations:^{
            blurEffectView.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
//            if (finished) {
//                toVC.view.hidden = NO;
//                fromView.hidden = NO;
//            }
        }];
        
    } else {
        
        [UIView animateWithDuration:duration animations:^{
            
        }];

    }
    
}

@end
