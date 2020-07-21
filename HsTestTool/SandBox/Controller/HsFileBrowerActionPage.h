//
//  HsFileBrowerActionPage.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/30.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HsFileBrowerActionPage, HsFileBrowerItem;

@protocol HsFileBrowerActionPageDelegate <NSObject>

@optional

- (void)actionPage:(HsFileBrowerActionPage *)actionPage didSelectAction:(NSString *)actionName;

@end

@interface HsFileBrowerActionPage : HsTestBaseViewController

- (instancetype)initWithItem:(HsFileBrowerItem *)item actionNames:(NSArray<NSArray<NSString *> *> *)actionNames sourceView:(UIView *)sourceView;

@property (readonly) HsFileBrowerItem *item;

@property (readonly) UIView *sourceView;

@property (nonatomic, weak) id<HsFileBrowerActionPageDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
