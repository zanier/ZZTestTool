//
//  ZZPlistBrowerPage.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/4.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// Plist 浏览界面，用于调试查看 Info.plist、JF-info.plist 等文件
@interface ZZPlistBrowerPage : ZZTestBaseViewController

/// 初始化方法
- (instancetype)init;

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
