//
//  HsFileBrowerPageViewController.h
//  HsBusinessEngine
//
//  Created by ZZ on 2020/6/4.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HsFileBrowerPage, HsFileBrowerItem;

@protocol HsFileBrowerPageDelegate <NSObject>

/// 点击都个单元格进入下级页面
/// @param page 当前页面
/// @param item 文件数据
- (void)filePage:(HsFileBrowerPage *)page didSlectItem:(HsFileBrowerItem *)item;

@end

@interface HsFileBrowerPage : HsTestBaseViewController

@property (nonatomic, weak) id<HsFileBrowerPageDelegate> delegate;

/// 当前页面数据
@property (nonatomic, strong) HsFileBrowerItem *item;

/// 刷新显示指定文件夹下的文件
/// @param item 文件夹数据
- (void)reloadAtDirectoryWithItem:(HsFileBrowerItem *)item;

@end

NS_ASSUME_NONNULL_END
