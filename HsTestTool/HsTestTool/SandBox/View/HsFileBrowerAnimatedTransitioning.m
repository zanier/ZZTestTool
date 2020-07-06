//
//  HsFileBrowerAnimatedTransitioning.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/30.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsFileBrowerAnimatedTransitioning.h"

@implementation HsFileBrowerAnimatedTransitioning

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
    
    NSTimeInterval duration = [self transitionDuration:nil];
    
    if (_isPresented) {
        /// present
        toVC.view.frame = UIScreen.mainScreen.bounds;
        UIView *fromView = _sourceView;
        //CGRect oldFrame = [fromView convertRect:fromView.bounds toView:containerView];
        CGRect newFrame = UIScreen.mainScreen.bounds;
        /// tempView
        UIView *tempView = [[UIView alloc] init];
        tempView.frame = UIScreen.mainScreen.bounds;
        /// blurEffectView
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        blurEffectView.frame = UIScreen.mainScreen.bounds;
        [tempView addSubview:blurEffectView];
        /// toVC
        toVC.view.hidden = YES;
        /// add subviews
        [containerView addSubview:tempView];
        [containerView addSubview:toVC.view];
        /// hide from imageView
        fromView.hidden = YES;
        /// animation
        [UIView animateWithDuration:duration animations:^{
            tempView.frame = newFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                toVC.view.hidden = NO;
                fromView.hidden = NO;
            }
            
        }];
        
    } else {
        
        [UIView animateWithDuration:duration animations:^{
            
        }];

    }
    
}

@end
