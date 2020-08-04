//
//  ZZFileBrowerAnimatedTransitioning.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/30.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZFileBrowerAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithSourceView:(UIView *)sourceView isPresented:(BOOL)isPresented;

@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIView *menuView;

@end

NS_ASSUME_NONNULL_END
