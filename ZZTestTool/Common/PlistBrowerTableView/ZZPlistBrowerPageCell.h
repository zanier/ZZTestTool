//
//  ZZPlistBrowerPageCell.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/8.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZPlistBrowerNode;

NS_ASSUME_NONNULL_BEGIN

@interface ZZPlistBrowerPageCell : UITableViewCell

/// 结点
@property (nonatomic, strong) ZZPlistBrowerNode *node;

/// 高亮搜索的文字
/// @param searchText 搜索文字
- (void)highlightSearchText:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
