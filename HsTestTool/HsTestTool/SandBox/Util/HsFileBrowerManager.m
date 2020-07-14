//
//  HsFileBrowerManager.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/30.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsFileBrowerManager.h"
#import "HsFileBrowerItem.h"
#import "NSBundle+HsTestTool.h"

@interface HsFileBrowerManager ()

@property (nonatomic, copy, readwrite) NSString *dealtPath;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation HsFileBrowerManager

static HsFileBrowerManager *manager;
static dispatch_once_t onceToken;

+ (instancetype)manager {
    dispatch_once(&onceToken, ^{
        manager = [[HsFileBrowerManager alloc] init];
    });
    return manager;
}

+ (void)deallocManager {
    manager = nil;
    onceToken = 0;
}

- (BOOL)hasDealtPath {
    return [[self class] isLegalPath:_dealtPath];
}

static NSString *const HsFileBrowerErrorDomin = @"HsFileBrowerErrorDomin";

+ (NSError *)error_invalidFilePath:(NSString *)path {
    NSString *desc = [NSString stringWithFormat:@"Invalid file path: %@", path];
    return [NSError errorWithDomain:HsFileBrowerErrorDomin code:-1 userInfo:@{
        NSLocalizedDescriptionKey : desc,
    }];
}

+ (NSError *)error_invalidFileName:(NSString *)name {
    NSString *desc = [NSString stringWithFormat:@"Invalid file name: %@", name];
    return [NSError errorWithDomain:HsFileBrowerErrorDomin code:-1 userInfo:@{
        NSLocalizedDescriptionKey : desc,
    }];
}

/// MARK: - create item

/// 获取子文件的个数
/// @param item 文件数据
+ (NSUInteger)contentCountWithDirectoryItem:(HsFileBrowerItem *)item {
    if (item.isDir) {
        NSArray<NSString *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:item.path error:nil];
        return contents.count;
    }
    return 0;
}

/// 获取item的子文件数据
/// @param parent 文件夹item
+ (NSArray<HsFileBrowerItem *> *)contentItemsOfItem:(HsFileBrowerItem *)parent {
    NSError *error = nil;
    NSString *childPath = nil;
    NSArray<NSString *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:parent.path error:nil];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:contents.count];
    for (NSString *content in contents) {
        childPath = [parent.path stringByAppendingPathComponent:content];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:childPath error:&error];
        if (error) {
            NSLog(@"error: %@", error);
            continue;
        }
        HsFileBrowerItem *child = [[HsFileBrowerItem alloc] initWithPath:childPath];
        child.attributes = attributes;
        child.parent = parent;
        child.childrenCount = [self contentCountWithDirectoryItem:child];
        [items addObject:child];
    }
    parent.children = items;
    return items;
}

+ (HsFileBrowerItem *)createItemAtPath:(NSString *)path error:(NSError **)error {
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
    if (error) {
        NSLog(@"error: %@", *error);
        return nil;
    }
    HsFileBrowerItem *item = [[HsFileBrowerItem alloc] initWithPath:path];
    item.attributes = attributes;
    return item;
}


/// MARK: deal with path

/// 检查路径是否有效
/// @param path 文件路径
+ (BOOL)isLegalPath:(NSString *)path {
    if (!path || ![path isKindOfClass:[NSString class]] || path.length == 0) return NO;
    NSString *regex = @"(^//.|^/|^[a-zA-Z])?:?/.+(/$)?";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:path];
}

/// 判断文件名是否合法
/// @param name 文件名
+ (BOOL)isLegalFileName:(NSString *)name {
    if (!name || ![name isKindOfClass:[NSString class]] || name.length == 0) return NO;
    NSString *regex = @"^[\u4E00-\u9FA5A-Za-z0-9_ ]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:name];
}

/// 创建文件夹
/// 返回是否创建成功，若路径已存在则不创建并返回 NO。
/// @param path 目标路径
/// @param error 错误
+ (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError **)error {
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
}

/// 删除文件
/// @param path 文件路径
/// @param error 错误
+ (void)removeItemAtPath:(NSString *)path error:(NSError **)error {
    if (![self isLegalPath:path]) {
        *error = [self error_invalidFilePath:path];
        return;
    }
    [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

/// 重命名文件
/// @param path 文件路径
/// @param error 错误
+ (void)renameItemAtPath:(NSString *)path name:(NSString *)name error:(NSError **)error {
    if (![self isLegalPath:path]) {
        *error = [self error_invalidFilePath:path];
        return;
    }
    if (![self isLegalFileName:name]) {
        *error = [self error_invalidFileName:name];
        return;
    }
    NSString *newPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:name];
    [[NSFileManager defaultManager] moveItemAtPath:path toPath:newPath error:error];
}

/// 记录待处理文件路径，由于粘贴、移动等
/// @param path 文件路径
+ (void)dealWithPath:(NSString *)path {
    [HsFileBrowerManager manager].dealtPath = path;
}

/// 复制文件
/// @param atPath 原文件路径
/// @param toPath 目标路径
/// @param error 错误
+ (void)copyItemAtPath:(NSString *)atPath toPath:(NSString *)toPath error:(NSError **)error {
    if (![self isLegalPath:atPath]) {
        *error = [self error_invalidFilePath:atPath];
        return;
    }
    if (![self isLegalPath:toPath]) {
        *error = [self error_invalidFilePath:toPath];
        return;
    }
    [[NSFileManager defaultManager] copyItemAtPath:atPath toPath:toPath error:error];
}

/// 移动待处理文件
/// @param toPath 目标路径
/// @param error 错误
+ (void)moveToPath:(NSString *)toPath error:(NSError **)error {
    NSString *path = [HsFileBrowerManager manager].dealtPath;
    if (![self isLegalPath:path]) return;
    [[NSFileManager defaultManager] moveItemAtPath:path toPath:toPath error:error];
    [HsFileBrowerManager manager].dealtPath = nil;
}

/// 移动文件
/// @param path 原路径
/// @param toPath 目标路径
/// @param error 错误
+ (void)moveAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error {
    [self dealWithPath:path];
    if (![self isLegalPath:path]) return;
    [self moveToPath:path error:error];
}

/// MARK: deal with item

//+ (void)removeItem:(HsFileBrowerItem *)item error:(NSError **)error {
//    [self removeItemAtPath:item.path error:error];
//}
//
//+ (void)renameItem:(HsFileBrowerItem *)item name:(NSString *)name error:(NSError **)error {
//    [self renameItemAtPath:item.path name:name error:error];
//}

//+ (void)copyItem:(HsFileBrowerItem *)item {
//    [self dealWithPath:item.path];
//}

/// MARK: - date formatter

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

+ (NSString *)stringFromDateByDateAndTime:(NSDate *)date {
    [HsFileBrowerManager.manager.dateFormatter setDateFormat:@"YYYY年MM月DD日 mm:ss"];
    return [HsFileBrowerManager.manager.dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDateByDate:(NSDate *)date {
    [HsFileBrowerManager.manager.dateFormatter setDateFormat:@"YYYY年MM月DD日"];
    return [HsFileBrowerManager.manager.dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDateByTime:(NSDate *)date {
    [HsFileBrowerManager.manager.dateFormatter setDateFormat:@"mm:ss"];
    return [HsFileBrowerManager.manager.dateFormatter stringFromDate:date];
}

/// MARK: - other

/// 获取复制文件的名称
/// @param name 源文件的名称
/// @param items 源文件所在文件夹的所有文件
+ (NSString *)duplicateNameWithOriginName:(NSString *)name amongItems:(NSArray<HsFileBrowerItem *> *)items {
    NSString *duplicateName;
    NSString *noComponentName = name;
    NSString *extension = nil;
    if ([name rangeOfString:@"."].location != NSNotFound) {
        noComponentName = [name stringByDeletingLastPathComponent];
        extension = name.pathExtension;
    }
    for (int i = 0; i < INT32_MAX; i++) {
        duplicateName = noComponentName;
        if (i > 0) {
            duplicateName = [duplicateName stringByAppendingFormat:@" %d", i];
        }
        BOOL exist = NO;
        for (HsFileBrowerItem *child in items) {
            if ([duplicateName isEqualToString:child.name]) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            if (extension) {
                duplicateName = [duplicateName stringByAppendingPathExtension:extension];
            }
            return duplicateName;
        }
    }
    return nil;
}

/// 文件大小转换为字符串
/// @param size 文件大小，单位字节
+ (NSString *)sizeStringFromSize:(long long)size {
    float rank = 1024.0;
    float s = (float)size;
    int i = 0;
    while (s > rank) {
        s /= rank;
        i++;
    }
    static char *array[] = {"B", "KB", "MB", "GB", "TB", nil};
    s = ((int)(s * 100)) / 100.0;
    return [NSString stringWithFormat:@"%.1f %s", s, array[i]];
}

+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF: return @"image/jpeg";
        case 0x89: return @"image/png";
        case 0x47: return @"image/gif";
        case 0x49:
        case 0x4D: return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            return nil;
    }
    return nil;
}

//+ (HsFileBrowerFileType)fileTypeWithExtension:(NSString *)extension;
//+ (NSString *)imageNameWithType:(HsFileBrowerFileType)type;
//+ (UIImage *)imageNameWithItem:(HsFileBrowerItem *)item;

+ (UIImage *)imageWithFileType:(HsFileBrowerFileType)type scale:(NSInteger)scale {
    NSString *imageName = HsImageNameWithType(type);
    switch (scale) {
        case 1: break;
        case 2: imageName = [NSString stringWithFormat:@"%@@2x", imageName]; break;
        case 3: imageName = [NSString stringWithFormat:@"%@@3x", imageName]; break;
        default: break;
    }
    UIImage *image = [NSBundle hs_imageNamed:imageName type:@"png" inDirectory:@"FileType"];
    return image;
}

+ (UIImage *)imageWithFileType:(HsFileBrowerFileType)type {
    NSString *imageName = HsImageNameWithType(type);
    NSString *x1ImageName = imageName;
    NSString *x2ImageName = [NSString stringWithFormat:@"%@@2x", imageName];
    NSString *x3ImageName = [NSString stringWithFormat:@"%@@3x", imageName];
    NSInteger scale = (NSInteger)[UIScreen mainScreen].scale;
    UIImage *image;
    switch (scale) {
        case 1:
            image = [NSBundle hs_imageNamed:x1ImageName type:@"png" inDirectory:@"FileType"];
            if (image) return image;
        case 2:
            image = [NSBundle hs_imageNamed:x2ImageName type:@"png" inDirectory:@"FileType"];
            if (image) return image;
        case 3:
            image = [NSBundle hs_imageNamed:x3ImageName type:@"png" inDirectory:@"FileType"];
            if (image) return image;
        default:
            image = [NSBundle hs_imageNamed:x1ImageName type:@"png" inDirectory:@"FileType"];
            if (image) return image;
            image = [NSBundle hs_imageNamed:x2ImageName type:@"png" inDirectory:@"FileType"];
            if (image) return image;
            image = [NSBundle hs_imageNamed:x3ImageName type:@"png" inDirectory:@"FileType"];
            if (image) return image;
    }
    return image;
}


/// 操作栏目图标
/// @param text 操作名称
+ (UIImage *)imageWithActionText:(NSString *)text {
    NSString *imageName = HsActionImageNameWithActionText(text);
    UIImage *image = [NSBundle hs_imageNamed:imageName type:@"png" inDirectory:@"ActionIcon"];

    return image;
}

@end
