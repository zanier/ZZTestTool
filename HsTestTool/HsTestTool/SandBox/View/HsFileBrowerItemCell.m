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

@property (nonatomic, strong) UIButton *button;

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

- (void)setupSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailLabel];
    //_imageView.backgroundColor = [UIColor grayColor];
    //_textLabel.backgroundColor = UIColor.lightTextColor;
    //_detailLabel.backgroundColor = UIColor.orangeColor;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    longPress.minimumPressDuration = 0.5;
    [self.contentView addGestureRecognizer:longPress];
    
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(cellDidLongPressed:)]) {
            [_delegate cellDidLongPressed:self];
        }
    }
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
    _textLabel.frame = CGRectMake(8, CGRectGetMaxY(_imageView.frame) + 10, labelWidth, textHeight);
    _detailLabel.frame = CGRectMake(8, CGRectGetMaxY(_textLabel.frame), labelWidth, detailHeight);
}

- (void)setItem:(HsFileBrowerItem *)item {
    _item = item;
    [self reloadItem];
    [self setNeedsLayout];
}

- (void)reloadItem {
    self.textLabel.text = _item.name;
    self.detailLabel.text = [NSString stringWithFormat:@"%@", _item.modificationDate];
    _imageView.image = [HsFileBrowerManager imageNameWithItem:_item];
}

- (void)beginRenamingItem {
    self.textLabel.hidden = YES;
    self.detailLabel.hidden = YES;
    self.renameTextView.hidden = NO;
    self.renameTextView.text = _item.name;
    if (!self.renameTextView.superview) {
        [self.contentView addSubview:self.renameTextView];
    }
    [self.renameTextView becomeFirstResponder];
}

- (void)endRenamingItem {
    [self.renameTextView resignFirstResponder];
    self.renameTextView.hidden = YES;
    self.textLabel.hidden = NO;
    self.detailLabel.hidden = NO;
}

/// MARK: - <UITextViewDelegate>

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(cell:shouldEndRenamingWithName:)]) {
        return [_delegate cell:self shouldEndRenamingWithName:textView.text];
    }
    return YES;;
}

/// MARK: - button

//- (UIButton *)button {
//    if (_button) {
//        return _button;
//    }
//    _button = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_button addTarget:self action:@selector(image) forControlEvents:UIControlEventTouchDown];
//
//    return _button;
//}

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
    _renameTextView.backgroundColor = UIColor.lightGrayColor;
    _renameTextView.layer.cornerRadius = 5.0f;
    _renameTextView.layer.masksToBounds = YES;
    _renameTextView.showsVerticalScrollIndicator = YES;
    _renameTextView.showsHorizontalScrollIndicator = NO;
    _renameTextView.delegate = self;
    return _renameTextView;
}

@end
