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
    [self.contentView setNeedsLayout];
}

- (void)reloadItem {
    self.textLabel.text = _item.name;
    self.detailLabel.text = [NSString stringWithFormat:@"%@", _item.modificationDate];
    NSString *typeString = [_item.extension lowercaseString];
    if ([typeString isEqualToString:@"png"] || [typeString isEqualToString:@"jpeg"] || [typeString isEqualToString:@"gif"] || [typeString isEqualToString:@"psd"] || [typeString isEqualToString:@"jpg"]) {
        NSData *imageData = [NSData dataWithContentsOfFile:_item.path options:NSDataReadingMappedIfSafe error:nil];
        _imageView.image = [UIImage imageWithData:imageData];
    } else {
        self.imageView.image = [HsFileBrowerManager imageWithFileType:_item.type];
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

/// MARK: - <UITextViewDelegate>

/// 文字改变
- (void)textViewDidChange:(UITextView *)textView {
    /// 改变输入框布局
    [textView sizeToFit];
    CGRect frame = self.renameTextView.frame;
    frame.origin.x = (CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(self.renameTextView.bounds)) / 2;
    self.renameTextView.frame = frame;
}

/// 文字是否允许改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text]) {
        /// return 键换行，结束编辑
        [textView resignFirstResponder];
        /// 代理回调
        if ([_delegate respondsToSelector:@selector(cell:shouldEndRenamingWithName:)]) {
            [_delegate cell:self shouldEndRenamingWithName:self.renameTextView.text];
        }
        return NO;
    }
    return YES;
}


/// MARK: - layout

- (void)setupSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.renameTextView];
    self.renameTextView.hidden = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.contentView addGestureRecognizer:longPress];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentWidth = CGRectGetWidth(self.contentView.bounds);
    CGFloat labelWidth = contentWidth - 16.0f;
    CGFloat imageWidth = 65.0f;
    _imageView.frame = CGRectMake((contentWidth - imageWidth) / 2, 10, imageWidth, imageWidth);
    CGSize fitedSize = [_textLabel sizeThatFits:CGSizeMake(labelWidth, 42)];
    CGSize detailFitedSize = [_detailLabel sizeThatFits:CGSizeMake(labelWidth, 42)];
    CGFloat textHeight = fitedSize.height < 42 ? fitedSize.height : 42;
    CGFloat detailHeight = detailFitedSize.height < 42 ? detailFitedSize.height : 42;
    _textLabel.frame = CGRectMake(8, CGRectGetMaxY(_imageView.frame) + 10, labelWidth, textHeight + 0);
    _detailLabel.frame = CGRectMake(8, CGRectGetMaxY(_textLabel.frame), labelWidth, detailHeight + 0);
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
