//
//  HsPlistBrowerSearchResultPage.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/22.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsTestBaseViewController.h"

@class HsPlistBrowerNode, HsPlistBrowerTableView;

NS_ASSUME_NONNULL_BEGIN

@interface HsPlistBrowerSearchResultPage : HsTestBaseViewController <UISearchResultsUpdating>

@property (nonatomic, strong) id object;

@property (nonatomic, weak) UISearchController *searchController;

@property (readonly) HsPlistBrowerTableView *browerTableView;

@end

NS_ASSUME_NONNULL_END
