//
//  HsPlistBrowerNodeView.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/22.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "HsPlistBrowerNodeView.h"
#import "HsPlistBrowerNode.h"

@interface HsPlistBrowerNodeView () <UITextViewDelegate> {
    CGFloat _selfHeight;
    CGSize _keyTextSize;
    CGSize _valueTextSize;
}
@property (nonatomic, assign, getter=isPresented) BOOL presented;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UITextView *keyTextView;
@property (nonatomic, strong) UITextView *valueTextView;
@property (nonatomic, strong) UIButton *undoBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation HsPlistBrowerNodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setNode:(HsPlistBrowerNode *)node {
    _node = node;
    if (node.key && [node.key isKindOfClass:[NSString class]]) {
        _keyTextView.text = node.key;
        _keyTextView.textColor = UIColor.blackColor;
    } else {
        _keyTextView.text = @"empty";
        _keyTextView.textColor = UIColor.grayColor;
    }
    if (node.value && [node.value isKindOfClass:[NSString class]]) {
        _valueTextView.text = node.value;
    } else {
        _valueTextView.text = node.typeString;
    }
}

/// 显示视图
/// @param view 父视图
/// @param animated 是否添加动画
- (void)showAtView:(UIView *)view animated:(BOOL)animated {
    if (self.superview != view) {
        [self removeFromSuperview];
        [view addSubview:self];
    }
    if (_presented) {
        return;
    }
    [self setNeedsLayout];
    CGFloat marginH = 18.0f;
    self.frame = CGRectMake(marginH, CGRectGetHeight(view.bounds), CGRectGetWidth(view.bounds) - marginH * 2, _selfHeight);
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = self.frame;
            frame.origin.y = CGRectGetHeight(self.superview.bounds) - 18.0f - CGRectGetHeight(self.bounds);
            self.frame = frame;
        }];
    } else {
        CGRect frame = self.frame;
        frame.origin.y = CGRectGetHeight(self.superview.bounds) - 18.0f - CGRectGetHeight(self.bounds);
        self.frame = frame;
    }
    _presented = YES;
}

/// 隐藏视图，不从父视图上移除
/// @param animated 是否添加动画
- (void)hideAnimated:(BOOL)animated {
    if (!_presented) {
        return;
    }
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = CGRectGetHeight(self.superview.bounds);
            self.frame = frame;
        }];
    } else {
        CGRect frame = self.frame;
        frame.origin.y = CGRectGetHeight(self.superview.bounds);
        self.frame = frame;
    }
    _presented = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat marginH = 18.0f;
    CGFloat marginV = 5.0f;
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    
    CGFloat keyTextHeight = [_keyTextView sizeThatFits:CGSizeMake(selfWidth - marginH * 2, CGFLOAT_MAX)].height;
    CGFloat valueTextHeight = [_valueTextView sizeThatFits:CGSizeMake(selfWidth - marginH * 2, CGFLOAT_MAX)].height;
    
    _keyLabel.frame = CGRectMake(marginH, marginH, selfWidth - marginH * 2, 21);
    _closeBtn.frame = CGRectMake(selfWidth - marginH - 80, marginH, 80, 21);
    _keyTextView.frame = CGRectMake(marginH, CGRectGetMaxY(_keyLabel.frame) + marginV, selfWidth - marginH * 2, keyTextHeight);
    _valueLabel.frame = CGRectMake(marginH, CGRectGetMaxY(_keyTextView.frame) + marginV, selfWidth - marginH * 2, 21);
    _valueTextView.frame = CGRectMake(marginH, CGRectGetMaxY(_valueLabel.frame) + marginV, selfWidth - marginH * 2, valueTextHeight);
    // layout buttons
    CGFloat btnWidth = (selfWidth - marginH * 3) / 2;
    _undoBtn.frame = CGRectMake(marginH, CGRectGetMaxY(_valueTextView.frame) + marginV, btnWidth, 28);
    _saveBtn.frame = CGRectMake(marginH + btnWidth + marginH, CGRectGetMaxY(_valueTextView.frame) + marginV, btnWidth, 28);
    // layout self
    CGRect frame = self.frame;
    CGFloat bootom = CGRectGetMaxY(frame);
    _selfHeight = CGRectGetMaxY(_saveBtn.frame) + marginH;
    frame.size.height = _selfHeight;
    if (_presented) {
        frame.origin.y = bootom - frame.size.height;
    }
    self.frame = frame;
    _contentView.frame = self.bounds;
}

/// MARK: -

- (void)setupSubviews {
    
    _contentView = [[UIView alloc] init];
    _contentView.layer.cornerRadius = 10.0f;
    _contentView.backgroundColor = UIColor.groupTableViewBackgroundColor;
    [self addSubview:_contentView];
    
    _keyLabel = [[UILabel alloc] init];
    _keyLabel.text = @"Key";
    _keyLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.contentView addSubview:_keyLabel];
    
    _keyTextView = [[UITextView alloc] init];
    _keyTextView.backgroundColor = UIColor.whiteColor;
    _keyTextView.layer.cornerRadius = 10.0f;
    _keyTextView.font = [UIFont systemFontOfSize:17.0f];
    _keyTextView.delegate = self;
    [self.contentView addSubview:_keyTextView];
    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.text = @"Value";
    _valueLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.contentView addSubview:_valueLabel];

    _valueTextView = [[UITextView alloc] init];
    _valueTextView.backgroundColor = UIColor.whiteColor;
    _valueTextView.layer.cornerRadius = 10.0f;
    _valueTextView.font = [UIFont systemFontOfSize:17.0f];
    _valueTextView.delegate = self;
    [self.contentView addSubview:_valueTextView];
    
    _undoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
    [_undoBtn addTarget:self action:@selector(undoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_undoBtn];

    _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_saveBtn];

    _closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_closeBtn];

}

/// MARK: - button action

- (void)undoAction:(UIButton *)button {
    [self setNode:_node];
}

- (void)saveAction:(UIButton *)button {
    
}

- (void)closeAction:(UIButton *)button {
    [self hideAnimated:YES];
}

/// MARK: - <UITextViewDelegate>

- (void)textViewDidChange:(UITextView *)textView {
    [self setNeedsLayout];
}

@end
