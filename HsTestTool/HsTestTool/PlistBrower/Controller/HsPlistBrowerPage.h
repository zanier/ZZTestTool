//
//  HsPlistBrowerPage.h
//  HsBusinessEngine
//
//  Created by ZZ on 2020/6/4.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// `createPage:` 参数中基本类型对象的key
static NSString *const HsPlistBrowerPageObjectCreateKey = @"HsPlistBrowerPageObjectCreateKey";
/// `createPage:` 参数中Plist文件路径的key
static NSString *const HsPlistBrowerPagePlsitFilePathCreateKey = @"HsPlistBrowerPagePlsitFilePathCreateKey";

/// Plist 浏览界面，用于调试查看 Info.plist、JF-info.plist 等文件
@interface HsPlistBrowerPage : HsTestBaseViewController

+ (id)createPage:(NSDictionary*)params;

/// 初始化方法
/// @param anObject 基本类型数据，如NSArray、NSDictionary、NSString、NSNumber、NSData等
- (instancetype)initWithObject:(id)anObject;

/// 初始化方法
/// @param path plist文件路径
- (instancetype)initWithPlistFilePath:(NSString *)path;

@property (nonatomic, strong) id object;

@property (nonatomic, nullable, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
