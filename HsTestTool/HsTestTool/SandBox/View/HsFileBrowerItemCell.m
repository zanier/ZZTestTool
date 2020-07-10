//
//  HsFileBrowerItemCell.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/28.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsFileBrowerItemCell.h"
#import "HsFileBrowerManager.h"

@interface HsFileBrowerItemCell () <UITextViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextView *renameTextView;

@end

@implementation HsFileBrowerItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setItem:(HsFileBrowerItem *)item {
    _item = item;
    [self reloadItem];
    [self setNeedsLayout];
}

- (void)reloadItem {
    self.textLabel.text = _item.name;
    if (_item.isDir) {
        self.imageView.image = [HsFileBrowerManager imageWithFileType:_item.type];
        self.detailLabel.text = [NSString stringWithFormat:@"%li 项", _item.childrenCount];
    } else if (_item.isImage) {
        NSData *imageData = [NSData dataWithContentsOfFile:_item.path options:NSDataReadingMappedIfSafe error:nil];
        self.imageView.image = [UIImage imageWithData:imageData];
        self.detailLabel.text = [NSString stringWithFormat:@"%@", _item.sizeString];
    } else {
        self.imageView.image = [HsFileBrowerManager imageWithFileType:_item.type];
        self.detailLabel.text = [NSString stringWithFormat:@"%@", _item.modificationDate];
    }
}

/// MARK: - rename

- (void)beginRenamingItem {
    self.textLabel.hidden = YES;
    self.detailLabel.hidden = YES;
    self.renameTextView.hidden = NO;
    self.renameTextView.text = self.textLabel.text;
    [self textViewDidChange:self.renameTextView];
    [self.renameTextView becomeFirstResponder];
}

- (void)endRenamingItem {
    [self.renameTextView resignFirstResponder];
    self.renameTextView.hidden = YES;
    self.textLabel.hidden = NO;
    self.detailLabel.hidden = NO;
}

/// 长按单元格，代理回调
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(cellDidLongPressed:)]) {
            [_delegate cellDidLongPressed:self];
        }
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
//    if (selected) {
//        self.contentView.backgroundColor = [UIColor grayColor];
//    } else {
//        self.contentView.backgroundColor = [UIColor clearColor];
//    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        //self.contentView.backgroundColor = [UIColor grayColor];
        if ([self.imageView.layer animationForKey:@"animation"]) {
            return;
        }
        CAKeyframeAnimation *keyFrameAniamtion = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        keyFrameAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        keyFrameAniamtion.values = @[
            @(CGSizeMake(1.0, 1.0)),
            @(CGSizeMake(0.9, 0.9)),
            @(CGSizeMake(1.0, 1.0)),
        ];
        keyFrameAniamtion.repeatCount = 1;
        keyFrameAniamtion.duration = 0.5;
        keyFrameAniamtion.removedOnCompletion = YES;
        [self.imageView.layer addAnimation:keyFrameAniamtion forKey:@"animation"];
    } else {
        //self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
}

/// MARK: - <UITextViewDelegate>

/// 文字即将改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text]) {
        /// return 键换行，结束编辑
        /// 代理回调
        BOOL shouldEnd = YES;
        if ([_delegate respondsToSelector:@selector(cell:shouldEndRenamingWithName:)]) {
            shouldEnd = [_delegate cell:self shouldEndRenamingWithName:self.renameTextView.text];
        }
        if (shouldEnd) {
            [self endRenamingItem];
            [textView resignFirstResponder];
        }
        return shouldEnd;
    }
    return YES;
}

/// 文字发生改变
- (void)textViewDidChange:(UITextView *)textView {
    /// 改变输入框布局
    CGSize fitedSize = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.contentView.bounds), 42)];
    CGRect frame = self.renameTextView.frame;
    frame.size = fitedSize;
    frame.origin.x = (CGRectGetWidth(self.contentView.bounds) - fitedSize.width) / 2;
    self.renameTextView.frame = frame;
}

/// MARK: - layout

- (void)setupSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.renameTextView];
    self.renameTextView.hidden = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.3f;
    [self.contentView addGestureRecognizer:longPress];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat labelWidth = contentWidth;
    CGFloat imageWidth = 65.0f;
    _imageView.frame = CGRectMake((contentWidth - imageWidth) / 2, 10, imageWidth, imageWidth);
    CGSize fitedSize = [_textLabel sizeThatFits:CGSizeMake(labelWidth, 42)];
    CGSize detailFitedSize = [_detailLabel sizeThatFits:CGSizeMake(labelWidth, 42)];
    CGFloat textHeight = fitedSize.height < 42 ? fitedSize.height : 42;
    CGFloat detailHeight = detailFitedSize.height < 42 ? detailFitedSize.height : 42;
    _textLabel.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame) + 10, labelWidth, textHeight + 0);
    _detailLabel.frame = CGRectMake(0, CGRectGetMaxY(_textLabel.frame) + 5, labelWidth, detailHeight + 0);
    _renameTextView.frame = _textLabel.frame;
}

/// MARK: - getter

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    return _imageView;
}

- (UILabel *)textLabel {
    if (_textLabel) {
        return _textLabel;
    }
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:15.0f];
    _textLabel.textColor = [UIColor darkTextColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    return _textLabel;
}

- (UILabel *)detailLabel {
    if (_detailLabel) {
        return _detailLabel;
    }
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:12.0f];
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.numberOfLines = 0;
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    return _detailLabel;
}

- (UITextView *)renameTextView {
    if (_renameTextView) {
        return _renameTextView;
    }
    _renameTextView = [[UITextView alloc] init];
    _renameTextView.delegate = self;
    _renameTextView.font = [UIFont systemFontOfSize:15.0f];
    _renameTextView.textColor = [UIColor darkTextColor];
    _renameTextView.returnKeyType = UIReturnKeyDone;
    _renameTextView.textAlignment = NSTextAlignmentCenter;
    _renameTextView.layer.cornerRadius = 5.0f;
    _renameTextView.layer.masksToBounds = YES;
    _renameTextView.showsVerticalScrollIndicator = YES;
    _renameTextView.showsHorizontalScrollIndicator = NO;
    _renameTextView.backgroundColor = [UIColor colorWithWhite:(222.0/255) alpha:1.0];
    return _renameTextView;
}

@end
