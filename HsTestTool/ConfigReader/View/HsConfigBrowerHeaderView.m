//
//  HsConfigBrowerHeaderView.m
//  HsTestTool
//
//  Created by zanier on 2020/7/13.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "HsConfigBrowerHeaderView.h"

static CGFloat const HsConfigBrowerHeaderViewHeight = 49.0f;

@implementation HsConfigBrowerHeaderItem

@end

@interface HsConfigBrowerHeaderView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray<HsConfigBrowerHeaderItem *> *items;

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;

@end

@implementation HsConfigBrowerHeaderView

/// MARK: - init

+ (instancetype)viewWithextArray:(NSArray<NSString *> *)textArray {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    HsConfigBrowerHeaderView *view = [[HsConfigBrowerHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, HsConfigBrowerHeaderViewHeight) textArray:textArray];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame textArray:(NSArray<NSString *> *)textArray {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self setTextArray:textArray];
    }
    return self;
}

/// MARK: - setter

- (void)setTextArray:(NSArray<NSString *> *)textArray {
    if ([_textArray isEqualToArray:textArray]) {
        return;
    }
    _textArray = textArray.copy;
    NSMutableArray<HsConfigBrowerHeaderItem *> *items = [NSMutableArray arrayWithCapacity:textArray.count];
    [textArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HsConfigBrowerHeaderItem *item = [[HsConfigBrowerHeaderItem alloc] init];
        item.text = obj;
        [items addObject:item];
    }];
    [self setItems:items];
}

- (void)setItems:(NSArray<HsConfigBrowerHeaderItem *> *)items {
    if ([_items isEqualToArray:items]) {
        return;
    }
    _items = items.copy;
    [self setupSubView];
}

/// MARK: - subviews

- (void)clearSubviews {
    NSArray *buttonArray = self.buttonArray.copy;
    [buttonArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        [self.buttonArray removeObject:obj];
    }];
}

- (void)setupSubView {
    [self clearSubviews];
    if (!_items || _items.count <= 0) {
        return;
    }
    CGFloat margin = 16;
    CGFloat left = margin;
    UIButton *button;
    _buttonArray = [NSMutableArray arrayWithCapacity:_items.count];
    for (int i = 0; i < _items.count; i++) {
        button = [self buttonWithItem:_items[i]];
        CGRect frame = button.frame;
        frame.origin.x = left;
        button.frame = frame;
        button.tag = (i) * 10;
        [self.scrollView addSubview:button];
        [self.buttonArray addObject:button];
        left += frame.size.width + margin;
    }
    self.scrollView.contentSize = CGSizeMake(left, HsConfigBrowerHeaderViewHeight);
}

/// 移动到最后一个元素
- (void)scrollToIndex:(NSUInteger)idx animated:(BOOL)animated {
    if (idx >= self.buttonArray.count) {
        return;
    }
    [self.scrollView scrollRectToVisible:self.buttonArray[idx].frame animated:animated];
}

/// 每一级按钮操作
- (void)buttonAction:(UIButton *)button {
    BOOL shouldSelect = YES;
    NSInteger idx = button.tag / 10;
    if (_delegate && [_delegate respondsToSelector:@selector(scrollHeader:shouldSelectAtIndex:)]) {
        shouldSelect = [_delegate scrollHeader:self shouldSelectAtIndex:idx];
    }
    if (!shouldSelect) {
        return;
    }
    /// 改变状态
    [self selectAtIndex:idx];
    /// 执行代理方法
    if (_delegate && [_delegate respondsToSelector:@selector(scrollHeader:didSelectAtIndex:)]) {
        //NSInteger idx = depth / 10;
        [_delegate scrollHeader:self didSelectAtIndex:idx];
    }
}

/// 选中指定项
/// @param idx 项目索引
- (void)selectAtIndex:(NSUInteger)idx {
    if (idx >= self.buttonArray.count) {
        return;
    }
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    self.buttonArray[idx].selected = YES;
}

/// MARK: - getter

+ (CGFloat)defaultHeight {
    return HsConfigBrowerHeaderViewHeight;
}

- (UIButton *)buttonWithItem:(HsConfigBrowerHeaderItem *)item {
    //UIColor *btnBlue = [UIColor colorWithRed:(0x0D/255.0) green:(0x86/255.0) blue:(0xFF/255.0) alpha:1];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:item.text forState:UIControlStateNormal];
    [button setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button setImage:item.image forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 15, 0)]; //上左下右
    CGSize fitedSize = [button sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, HsConfigBrowerHeaderViewHeight)];
    button.frame = CGRectMake(0, 0, fitedSize.width, CGRectGetHeight(self.bounds));
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = item.selected;
    return button;
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
    //_scrollView.delegate = self;
    return _scrollView;
}

@end
