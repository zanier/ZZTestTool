//
//  ZZFileBrowerBriefPage.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/30.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZTestBaseViewController.h"

@class ZZFileBrowerItem;

//@protocol ZZFileBrowerBriefPageDelegate <NSObject>
//
//- (void)briefPage:(ZZFileBrowerBriefPage *)briefPage didOpenItem:(ZZFileBrowerItem *)item;
//
//@end

NS_ASSUME_NONNULL_BEGIN

@interface ZZFileBrowerBriefPage : ZZTestBaseViewController

- (instancetype)initWithItem:(ZZFileBrowerItem *)item;

@property (nonatomic, copy) void (^openItem)(ZZFileBrowerBriefPage *briefPage, ZZFileBrowerItem *item);

@end

NS_ASSUME_NONNULL_END
