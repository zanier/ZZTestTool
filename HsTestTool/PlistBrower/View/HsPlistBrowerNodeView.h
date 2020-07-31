//
//  HsPlistBrowerNodeView.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/22.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HsPlistBrowerNode;

NS_ASSUME_NONNULL_BEGIN

@interface HsPlistBrowerNodeView : UIView

@property (readonly, getter=isPresented) BOOL presented;

/// 结点
@property (nonatomic, strong) HsPlistBrowerNode *node;

/// 显示视图
/// @param view 父视图
/// @param animated 是否添加动画
- (void)showAtView:(UIView *)view animated:(BOOL)animated;

/// 隐藏视图，不从父视图上移除
/// @param animated 是否添加动画
- (void)hideAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
