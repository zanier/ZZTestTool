//
//  HsFileBrowerScrollHeader.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/28.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsFileBrowerScrollHeader.h"

static CGFloat const HsFileBrowerScrollHeaderHeight = 49.0f;

@interface HsFileBrowerScrollHeader () <UIScrollViewDelegate> {
    BOOL _needDisplayScrollView;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<NSString *> *mutableTextArray;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, strong) NSMutableArray<UIView *> *nextImgArray;

@end

@implementation HsFileBrowerScrollHeader

@dynamic textArray;

+ (instancetype)viewWithextArray:(NSArray<NSString *> *)textArray {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    HsFileBrowerScrollHeader *view = [[HsFileBrowerScrollHeader alloc] initWithFrame:CGRectMake(0, 0, width, HsFileBrowerScrollHeaderHeight) textArray:textArray];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame textArray:(NSArray<NSString *> *)textArray {
    if (self = [super initWithFrame:frame]) {
        _title = @"当前路径：";
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.titleLabel];
        _mutableTextArray = [textArray copy];
        _buttonArray = [NSMutableArray array];
        _nextImgArray = [NSMutableArray array];
        // 添加各级
        [_mutableTextArray enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
            [self pushText:text];
        }];
        [self reloadAnimated:NO];
    }
    return self;
}

/// MARK: -

- (void)setTextArray:(NSArray<NSString *> *)textArray {
    if (![_mutableTextArray isEqualToArray:textArray]) {
        _mutableTextArray = [textArray copy];
        [_buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_nextImgArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        _buttonArray = [NSMutableArray array];
        _nextImgArray = [NSMutableArray array];
        // 添加各级
        [_mutableTextArray enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
            [self pushText:text];
        }];
        [self reloadAnimated:YES];
    }
}

- (NSArray<NSString *> *)textArray {
    return [_mutableTextArray copy];
}

/*
 设置 tag 作为层级的深度
 当前选择：  button0 > button1 > button2 > button3
 tag/depth:  00    09  10    19  20    29  30
 */

/// MARK: reload
- (void)reloadAnimated:(BOOL)animated {
    // 最后一个按钮不能点击
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = !(idx == self.buttonArray.count - 1);
    }];
    // 布局 scrollView
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.buttonArray.lastObject.frame) + 16, 0);
    [self scrollToLastAnimated:animated];
}

/// MARK: public push
- (void)push:(NSString *)text {
    [self pushText:text];
    [self reloadAnimated:YES];
}

/// private push
- (void)pushText:(NSString *)text {
    if (!text) return;
    CGFloat left;
    NSInteger idx = self.buttonArray.count;
    if (idx == 0) {
        left = CGRectGetMaxX(self.titleLabel.frame);
    } else {
        left = CGRectGetMaxX(self.buttonArray.lastObject.frame);
        /// 已有 button 下，添加 nextImageView
        UIView *nextImageView = [self nextImageView];
        CGRect imgFrame = nextImageView.frame;
        imgFrame.origin.x = left;
        nextImageView.frame = imgFrame;
        nextImageView.tag = (idx) * 10 - 1;
        [self.scrollView addSubview:nextImageView];
        [self.nextImgArray addObject:nextImageView];
        left += CGRectGetWidth(nextImageView.bounds);
    }
    /// 添加 button
    UIButton *button = [self buttonWithText:text];
    CGRect frame = button.frame;
    frame.origin.x = left;
    button.frame = frame;
    button.tag = (idx) * 10;
    [self.scrollView addSubview:button];
    [self.buttonArray addObject:button];
    //left += CGRectGetWidth(button.bounds);
}

/// MARK: pop

/// 每一级按钮操作
- (void)buttonAction:(UIButton *)button {
    BOOL shouldSelect = YES;
    NSInteger idx = button.tag / 10;
    if (_delegate && [_delegate respondsToSelector:@selector(scrollHeader:shouldSelectAtIndex:)]) {
        shouldSelect = [_delegate scrollHeader:self shouldSelectAtIndex:idx];
    }
    if (shouldSelect) {
        [self popToDepth:button.tag];
    }
    // 执行代理方法
    if (_delegate && [_delegate respondsToSelector:@selector(scrollHeader:didSelectAtIndex:)]) {
        //NSInteger idx = depth / 10;
        [_delegate scrollHeader:self didSelectAtIndex:idx];
    }
}

/// MARK: - public pop 返回到上一级
- (void)pop {
    // 只剩一个不返回
    if (self.buttonArray.count <= 1) {
        return;
    }
    // 获取倒数第二个按钮的 tag/depth
    NSInteger depth = [self.buttonArray objectAtIndex:self.buttonArray.count - 2].tag;
    // 返回到倒数第二个按钮的 tag/depth
    [self popToDepth:depth];
}

/// MARK: - public pop 返回到指定一级
- (void)popToIndex:(NSInteger)idx {
    [self popToDepth:idx * 10];
}

/// MARK: - private pop 返回到某个 tag/depth
- (void)popToDepth:(NSInteger)depth {
    // depth 过大
    if (depth >= _nextImgArray.lastObject.tag) {
        return;
    }
    // 倒序遍历，移除 tag/depth 大于指定值 depth 的视图
    NSArray *buttonArray = self.buttonArray;
    [buttonArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag > depth) {
            [obj removeFromSuperview];
            [self.buttonArray removeObject:obj];
        } else {
            *stop = YES;
        }
    }];
    NSArray *nextImgArray = self.nextImgArray;
    [nextImgArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag > depth) {
            [obj removeFromSuperview];
            [self.nextImgArray removeObject:obj];
        } else {
            *stop = YES;
        }
    }];
    // 最后一个按钮不能点击
    self.buttonArray.lastObject.enabled = NO;
    // 布局 scrollView
    [self scrollToLastAnimated:YES];
    // 延时设置 scrollView 的 contentSize，`scrollViewDidEndScrollingAnimation:`
    _needDisplayScrollView = YES;
}

/// MARK: - 清除所有层级
- (void)clear {
    NSArray *buttonArray = self.buttonArray;
    [buttonArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        [self.buttonArray removeObject:obj];
    }];
    NSArray *nextImgArray = self.nextImgArray;
    [nextImgArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        [self.nextImgArray removeObject:obj];
    }];
    [_mutableTextArray removeAllObjects];
}

/// 移动到最后一个元素
- (void)scrollToLastAnimated:(BOOL)animated {
    CGFloat offsetX = MAX(CGRectGetMaxX(self.buttonArray.lastObject.frame) + 16 - [UIScreen mainScreen].bounds.size.width, 0);
    if (self.scrollView.contentOffset.x != offsetX) {
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
    }
}

/// MARK: - <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_needDisplayScrollView) {
        /// 在动画执行完再设置 contentSize
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.buttonArray.lastObject.frame) + 16, 0);
        _needDisplayScrollView = NO;
    }
}

/// MARK: - getter

+ (CGFloat)defaultHeight {
    return HsFileBrowerScrollHeaderHeight;
}

- (UIButton *)buttonWithText:(NSString *)text {
    UIColor *btnBlue = [UIColor colorWithRed:(0x0D/255.0) green:(0x86/255.0) blue:(0xFF/255.0) alpha:1];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:btnBlue forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        CGSize fitedSize = [button sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, HsFileBrowerScrollHeaderHeight)];
    button.frame = CGRectMake(0, 0, fitedSize.width, CGRectGetHeight(self.bounds));
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)nextImageView {
    /*
    UIImageView *nextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hsFileBrowerScrollHeader_next"]];
    nextImageView.contentMode = UIViewContentModeCenter;
    nextImageView.frame = CGRectMake(0, 0, 16, CGRectGetHeight(self.bounds));
    */
    UILabel *nextImageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, CGRectGetHeight(self.bounds))];
    nextImageView.text = @"/";
    nextImageView.textColor = [UIColor grayColor];
    nextImageView.textAlignment = NSTextAlignmentCenter;
    return nextImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _title;
    _titleLabel.textColor = [UIColor darkTextColor];
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    CGSize fitedSize = [_titleLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, HsFileBrowerScrollHeaderHeight)];
    _titleLabel.frame = CGRectMake(16, 0, fitedSize.width, CGRectGetHeight(self.bounds));
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    return _titleLabel;
}

- (UIScrollView *)scrollView {
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceHorizontal = YES;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _scrollView.delegate = self;
    return _scrollView;
}

- (NSMutableArray<NSString *> *)mutableTextArray {
    if (!_mutableTextArray) {
        _mutableTextArray = [NSMutableArray array];
    }
    return _mutableTextArray;
}

@end
