//
//  HsConfigBrowerPage.h
//  HsTestTool
//
//  Created by zanier on 2020/7/13.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "HsTestBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HsConfigBrowerPage : HsTestBaseViewController

/// 初始化方法
- (instancetype)init;

/// 初始化方法
/// @param objectDict 基本类型数据字典，如NSArray、NSDictionary、NSString、NSNumber、NSData等
- (instancetype)initWithObjectsDictionary:(NSDictionary<NSString *, id> *)objectDict;

/// 基本类型数据字典
@property (nonatomic, nullable, copy) NSDictionary<NSString *, id> *objectDict;

@end

NS_ASSUME_NONNULL_END
