//
//  HsConfigBrowerHeaderView.h
//  HsTestTool
//
//  Created by zanier on 2020/7/13.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HsConfigBrowerHeaderItem, HsConfigBrowerHeaderView;

@protocol HsConfigBrowerHeaderViewDelegate <NSObject>

@optional

/// 是否允许选择某一级，默认YES允许
/// @param scrollHeader 滑动选择视图
/// @param idx 选择级别索引
- (BOOL)scrollHeader:(HsConfigBrowerHeaderView *)scrollHeader shouldSelectAtIndex:(NSInteger)idx;

/// 选择了某一级
/// @param scrollHeader 滑动选择视图
/// @param idx 选择级别索引
- (void)scrollHeader:(HsConfigBrowerHeaderView *)scrollHeader didSelectAtIndex:(NSInteger)idx;

@end

@interface HsConfigBrowerHeaderItem : NSObject

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, nullable, strong) UIImage *image;
@property (nonatomic, nullable, copy) NSString *text;

@end

@interface HsConfigBrowerHeaderView : UIView

+ (instancetype)viewWithextArray:(NSArray<NSString *> *)textArray;

- (instancetype)initWithFrame:(CGRect)frame textArray:(NSArray<NSString *> *)textArray;

@property (nonatomic, strong) NSArray<NSString *> *textArray;

@property (nonatomic, nullable, weak) id<HsConfigBrowerHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
