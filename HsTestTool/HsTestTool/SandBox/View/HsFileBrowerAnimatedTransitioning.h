//
//  HsFileBrowerAnimatedTransitioning.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/30.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HsFileBrowerAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithSourceView:(UIView *)sourceView isPresented:(BOOL)isPresented;

@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIView *sourceView;

@end

NS_ASSUME_NONNULL_END
