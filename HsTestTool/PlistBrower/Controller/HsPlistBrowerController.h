//
//  HsPlistBrowerController.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/7/13.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// `createPage:` 参数中基本类型对象的key
static NSString *const HsPlistBrowerPageObjectCreateKey = @"HsPlistBrowerPageObjectCreateKey";
/// `createPage:` 参数中Plist文件路径的key
static NSString *const HsPlistBrowerPagePlsitFilePathCreateKey = @"HsPlistBrowerPagePlsitFilePathCreateKey";

@interface HsPlistBrowerController : HsTestBaseViewController

+ (instancetype)createPage:(nullable NSDictionary*)params;

@end

NS_ASSUME_NONNULL_END
