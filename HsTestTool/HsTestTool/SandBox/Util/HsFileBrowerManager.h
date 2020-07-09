//
//  HsFileBrowerUtil.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/30.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HsTestToolDefine.h"
#import "HsFileBrowerHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class HsFileBrowerItem;

static NSString *const HsFileBrowerActionPage_Copy      = @"复制";
static NSString *const HsFileBrowerActionPage_Paste     = @"粘贴";
static NSString *const HsFileBrowerActionPage_Move      = @"移动";
static NSString *const HsFileBrowerActionPage_Delete    = @"删除";
static NSString *const HsFileBrowerActionPage_Rename    = @"重命名";
static NSString *const HsFileBrowerActionPage_Brief     = @"简介";
static NSString *const HsFileBrowerActionPage_Share     = @"共享";

@interface HsFileBrowerManager : NSObject

+ (instancetype)manager;

@property (nonatomic, nullable, copy, readonly) NSString *dealtPath;

@property (readonly) BOOL hasDealtPath;

//+ (NSString *)imageNameWithType:(NSString *)typeString;
+ (HsFileBrowerFileType)fileTypeWithExtension:(NSString *)extension;
+ (NSString *)imageNameWithType:(HsFileBrowerFileType)type;
+ (UIImage *)imageNameWithItem:(HsFileBrowerItem *)item;

/// 获取item的子文件数据
/// @param parent 文件夹item
+ (NSArray<HsFileBrowerItem *> *)contentItemsOfItem:(HsFileBrowerItem *)parent;

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

/// 重命名文件
/// @param path 文件路径
/// @param error 错误
+ (void)renameItemAtPath:(NSString *)path error:(NSError **)error;

/// 记录待处理文件路径，由于粘贴、移动等
/// @param path 文件路径
+ (void)dealWithPath:(NSString *)path;

/// 粘贴待处理文件
/// @param toPath 目标路径
/// @param error 错误
+ (void)pasteToPath:(NSString *)toPath error:(NSError **)error;

/// 复制文件
/// @param path 原路径
/// @param toPath 目标路径
/// @param error 错误
+ (void)copyAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;

/// 移动待处理文件
/// @param toPath 目标路径
/// @param error 错误
+ (void)moveToPath:(NSString *)toPath error:(NSError **)error;

/// 移动文件
/// @param path 原路径
/// @param toPath 目标路径
/// @param error 错误
+ (void)moveAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;

///// MARK: deal with item
//+ (void)removeItem:(HsFileBrowerItem *)item error:(NSError **)error;
//+ (void)renameItem:(HsFileBrowerItem *)item error:(NSError **)error;
//+ (void)copyItem:(HsFileBrowerItem *)item;


/// 文件大小转换为字符串
/// @param size 文件大小
+ (NSString *)sizeStringFromSize:(long long)size;


+ (NSString *)stringFromDateByDateAndTime:(NSDate *)date;
+ (NSString *)stringFromDateByDate:(NSDate *)date;
+ (NSString *)stringFromDateByTime:(NSDate *)date;


@end

NS_ASSUME_NONNULL_END
