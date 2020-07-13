//
//  HsPlistBrowerTableView.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/22.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HsPlistBrowerTableView, HsPlistBrowerNode;

@protocol HsPlistBrowerTableViewDelegate <NSObject>

@optional

/// 长按单元格代理
/// @param plsitTableView plist 视图
/// @param node 结点
/// @param location 在 plist 视图上的长按位置
- (void)plistTableView:(HsPlistBrowerTableView *)plsitTableView
  didLongPressWithNode:(HsPlistBrowerNode *)node
              location:(CGPoint)location;

@end

@interface HsPlistBrowerTableView : UIView

/// 根节点
@property (nonatomic, strong) HsPlistBrowerNode *rootNode;

@property (nonatomic, weak) id<HsPlistBrowerTableViewDelegate> delegate;

/// 刷新界面
- (void)reloadData;

/// 切换指定结点的展开状态
/// @param node 结点
- (void)changeNodeExpanded:(HsPlistBrowerNode *)node;

/// 根据搜索字符串筛选显示结点
/// @param text 搜索字符串
- (void)searchText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
