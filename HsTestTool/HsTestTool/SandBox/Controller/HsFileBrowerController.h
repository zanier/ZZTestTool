//
//  HsFileBrowerController.h
//  HsTestTool
//
//  Created by handsome on 2020/7/5.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "HsTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// `createPage:` 参数中基本根目录的key
static NSString *const HsFileBrowerControllerRootPathKey = @"HsFileBrowerControllerRootPathKey";

@interface HsFileBrowerController : HsTestBaseViewController

+ (instancetype)createPage:(nullable NSDictionary*)params;

/// 初始化方法
/// @param rootPath 根目录文件路径，传 nil 则进入沙盒根目录
- (instancetype)initWithRootPath:(nullable NSString *)rootPath;

/// 根目录文件路径
@property (nonatomic, copy) NSString *rootPath;

@end

NS_ASSUME_NONNULL_END
