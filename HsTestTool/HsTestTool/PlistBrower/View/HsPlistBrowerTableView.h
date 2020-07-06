//
//  HsPlistBrowerTableView.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/22.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HsPlistBrowerNode;

NS_ASSUME_NONNULL_BEGIN

@interface HsPlistBrowerTableView : UIView

@property (nonatomic, strong) HsPlistBrowerNode *rootNode;

- (void)reloadData;

/// 切换指定结点的展开状态
/// @param node 结点
- (void)changeNodeExpanded:(HsPlistBrowerNode *)node;

- (void)searchText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
