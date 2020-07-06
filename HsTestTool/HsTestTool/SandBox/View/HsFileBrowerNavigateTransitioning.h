//
//  HsFileBrowerNavigateTransitioning.h
//  HsTestTool
//
//  Created by handsome on 2020/7/4.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HsFileBrowerNavigateTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithSourceView:(UIView *)sourceView isPresented:(BOOL)isPresented;

@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIView *sourceView;

@end

NS_ASSUME_NONNULL_END
