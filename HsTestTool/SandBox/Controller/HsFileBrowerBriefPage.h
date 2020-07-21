//
//  HsFileBrowerBriefPage.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/30.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsTestBaseViewController.h"

@class HsFileBrowerItem;

//@protocol HsFileBrowerBriefPageDelegate <NSObject>
//
//- (void)briefPage:(HsFileBrowerBriefPage *)briefPage didOpenItem:(HsFileBrowerItem *)item;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface HsFileBrowerBriefPage : HsTestBaseViewController

- (instancetype)initWithItem:(HsFileBrowerItem *)item;

@property (nonatomic, copy) void (^openItem)(HsFileBrowerBriefPage *briefPage, HsFileBrowerItem *item);

@end

NS_ASSUME_NONNULL_END
