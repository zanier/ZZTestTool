//
//  ZZFileBrowerUtil.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/30.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTestToolDefine.h"
#import "ZZFileBrowerHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZFileBrowerItem;

@interface ZZFileBrowerManager : NSObject

+ (instancetype)manager;

@property (nonatomic, nullable, copy, readonly) NSString *dealtPath;

@property (readonly) BOOL hasDealtPath;

+ (nullable UIImage *)imageWithFileType:(ZZFileBrowerFileType)type;
+ (nullable UIImage *)imageWithFileType:(ZZFileBrowerFileType)type scale:(NSInteger)scale;

/// 操作栏目图标
/// @param text 操作名称
+ (nullable UIImage *)imageWithActionText:(NSString *)text;

/// 检查路径是否有效
/// @param path 文件路径
+ (BOOL)isLegalPath:(NSString *)path;

/// 判断文件名是否合法
/// @param name 文件名
+ (BOOL)isLegalFileName:(NSString *)name;

/// 获取子文件的个数
/// @param item 文件数据
+ (NSUInteger)contentCountWithDirectoryItem:(ZZFileBrowerItem *)item;

/// 获取item的子文件数据
/// @param parent 文件夹item
+ (NSArray<ZZFileBrowerItem *> *)contentItemsOfItem:(ZZFileBrowerItem *)parent;

/// MARK: deal with path

/// 创建文件夹
/// 返回是否创建成功，若路径已存在则不创建并返回 NO。
/// @param path 目标路径
/// @param error 错误
+ (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError **)error;

/// 删除文件
/// @param path 文件路径
/// @param error 错误
+ (void)removeItemAtPath:(NSString *)path error:(NSError **)error;

///  重命名文件
/// @param path 文件路径
/// @param name 新文件名
/// @param error 错误
+ (void)renameItemAtPath:(NSString *)path name:(NSString *)name error:(NSError **)error;

/// 记录待处理文件路径，由于粘贴、移动等
/// @param path 文件路径
+ (void)dealWithPath:(NSString *)path;

/// 复制文件
/// @param atPath 原文件路径
/// @param toPath 目标路径
/// @param error 错误
+ (void)copyItemAtPath:(NSString *)atPath toPath:(NSString *)toPath error:(NSError **)error;

/// 移动待处理文件
/// @param toPath 目标路径
/// @param error 错误
+ (void)moveToPath:(NSString *)toPath error:(NSError **)error;

/// MARK: - other

/// 获取复制文件的名称
/// @param name 源文件的名称
/// @param items 源文件所在文件夹的所有文件
+ (NSString *)duplicateNameWithOriginName:(NSString *)name amongItems:(NSArray<ZZFileBrowerItem *> *)items;

/// 文件大小转换为字符串
/// @param size 文件大小，单位字节
+ (NSString *)sizeStringFromSize:(long long)size;

/// 日期格式化字符串
+ (NSString *)stringFromDateByDateAndTime:(NSDate *)date;
+ (NSString *)stringFromDateByDate:(NSDate *)date;
+ (NSString *)stringFromDateByTime:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
