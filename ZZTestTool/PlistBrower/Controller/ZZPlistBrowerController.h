//
//  ZZPlistBrowerController.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/7/13.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// `createPage:` 参数中基本类型对象的key
static NSString *const ZZPlistBrowerPageObjectCreateKey = @"ZZPlistBrowerPageObjectCreateKey";
/// `createPage:` 参数中Plist文件路径的key
static NSString *const ZZPlistBrowerPagePlsitFilePathCreateKey = @"ZZPlistBrowerPagePlsitFilePathCreateKey";

/// Plist 文件浏览页面
@interface ZZPlistBrowerController : ZZTestBaseViewController

/// 工程创建方法，参数内容参考上面的 key
+ (instancetype)createPage:(nullable NSDictionary*)params;

/// 初始化方法
/// @param anObject 基本类型数据，如NSArray、NSDictionary、NSString、NSNumber、NSData等
- (instancetype)initWithObject:(nullable id)anObject;

/// 初始化方法
/// @param path plist文件路径
- (instancetype)initWithPlistFilePath:(nullable NSString *)path;

/// plist 根结点数据
@property (nonatomic, nullable, strong) id object;

/// 根结点文件（.plist）路径
@property (nonatomic, nullable, copy) NSString *path;

@end

NS_ASSUME_NONNULL_END
