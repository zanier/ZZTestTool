//
//  ZZFileBrowerPageViewController.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/4.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZFileBrowerPage, ZZFileBrowerItem;

@protocol ZZFileBrowerPageDelegate <NSObject>

/// 点击都个单元格进入下级页面
/// @param page 当前页面
/// @param item 文件数据
- (void)filePage:(ZZFileBrowerPage *)page didSlectItem:(ZZFileBrowerItem *)item;

@end

@interface ZZFileBrowerPage : ZZTestBaseViewController

@property (nonatomic, weak) id<ZZFileBrowerPageDelegate> delegate;

/// 当前页面数据
@property (nonatomic, strong) ZZFileBrowerItem *item;

/// 刷新显示指定文件夹下的文件
/// @param item 文件夹数据
- (void)reloadAtDirectoryWithItem:(ZZFileBrowerItem *)item;

@end

NS_ASSUME_NONNULL_END
