//
//  ZZPlistBrowerTableView.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/22.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZPlistBrowerTableView, ZZPlistBrowerNode;

@protocol ZZPlistBrowerTableViewDelegate <NSObject>

@optional

/// 长按单元格代理
/// @param plsitTableView plist 视图
/// @param node 结点
/// @param location 在 plist 视图上的长按位置
- (void)plistTableView:(ZZPlistBrowerTableView *)plsitTableView
  didLongPressWithNode:(ZZPlistBrowerNode *)node
              location:(CGPoint)location;

@end

@interface ZZPlistBrowerTableView : UIView

/// 根节点
@property (nonatomic, strong) ZZPlistBrowerNode *rootNode;

@property (nonatomic, weak) id<ZZPlistBrowerTableViewDelegate> delegate;

/// 刷新界面
- (void)reloadData;

/// 切换指定结点的展开状态
/// @param node 结点
- (void)changeNodeExpanded:(ZZPlistBrowerNode *)node;

/// 根据搜索字符串筛选显示结点
/// @param text 搜索字符串
- (void)searchText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
