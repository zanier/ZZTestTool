//
//  ZZPlistBrowerSearchResultPage.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/22.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZTestBaseViewController.h"

@class ZZPlistBrowerNode, ZZPlistBrowerTableView;

NS_ASSUME_NONNULL_BEGIN

@interface ZZPlistBrowerSearchResultPage : ZZTestBaseViewController <UISearchResultsUpdating>

@property (nonatomic, strong) id object;

@property (nonatomic, weak) UISearchController *searchController;

@property (readonly) ZZPlistBrowerTableView *browerTableView;

@end

NS_ASSUME_NONNULL_END
