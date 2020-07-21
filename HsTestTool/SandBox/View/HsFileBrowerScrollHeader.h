//
//  HsFileBrowerScrollHeader.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/28.
//  Copyright © 2020 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HsFileBrowerScrollHeader;

@protocol HsFileBrowerScrollHeaderDelegate <NSObject>

@optional

/// 是否允许选择某一级，默认YES允许
/// @param scrollHeader 滑动选择视图
/// @param idx 选择级别索引
- (BOOL)scrollHeader:(HsFileBrowerScrollHeader *)scrollHeader shouldSelectAtIndex:(NSInteger)idx;

/// 选择了某一级
/// @param scrollHeader 滑动选择视图
/// @param idx 选择级别索引
- (void)scrollHeader:(HsFileBrowerScrollHeader *)scrollHeader didSelectAtIndex:(NSInteger)idx;

@end

@interface HsFileBrowerScrollHeader : UIView

+ (instancetype)viewWithextArray:(nullable NSArray<NSString *> *)textArray imageArray:(nullable NSArray<UIImage *> *)imageArray;
- (instancetype)initWithFrame:(CGRect)frame textArray:(nullable NSArray<NSString *> *)textArray imageArray:(nullable NSArray<UIImage *> *)imageArray;

@property (nonatomic, nullable, copy) NSString *title;  /// 标题文字，默认为 "当前路径："

@property (nonatomic, nullable, weak) id<HsFileBrowerScrollHeaderDelegate> delegate;

- (NSArray<NSString *> *)textArray;

/// 添加新的一级
/// @param text 新一级的文字
- (void)push:(NSString *)text;
- (void)push:(NSString *)text image:(UIImage *)image;

/// 弹出最后一级
- (void)pop;

/// 弹出到前面的某一级
/// @param idx 上级的索引
- (void)popToIndex:(NSInteger)idx;

/// 清除所有层级
- (void)clear;

/// 滑动到最后一级
/// @param animated 是否添加动画
- (void)scrollToLastAnimated:(BOOL)animated;

/// 默认高度为 49.0f
+ (CGFloat)defaultHeight;

@end

NS_ASSUME_NONNULL_END
