//
//  ZZFileBrowerActionPage.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/30.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZFileBrowerActionPage, ZZFileBrowerItem;

@protocol ZZFileBrowerActionPageDelegate <NSObject>

@optional

- (void)actionPage:(ZZFileBrowerActionPage *)actionPage didSelectAction:(NSString *)actionName;

@end

@interface ZZFileBrowerActionPage : ZZTestBaseViewController

- (instancetype)initWithItem:(ZZFileBrowerItem *)item actionNames:(NSArray<NSArray<NSString *> *> *)actionNames sourceView:(UIView *)sourceView;

@property (readonly) ZZFileBrowerItem *item;

@property (readonly) UIView *sourceView;

@property (nonatomic, weak) id<ZZFileBrowerActionPageDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
