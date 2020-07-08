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

@interface HsFileBrowerManager () {
    
}

@property (nonatomic, copy, readwrite) NSString *dealtPath;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation HsFileBrowerManager

static HsFileBrowerManager *manager;
static dispatch_once_t onceToken;

+ (instancetype)manager {
    printf("1 %ld\n", onceToken);
    dispatch_once(&onceToken, ^{
        printf("2 %ld\n", onceToken);
        manager = [[HsFileBrowerManager alloc] init];
    });
    printf("3 %ld\n", onceToken);
    return manager;
}

+ (void)deallocManager {
    manager = nil;
    onceToken = 0;
}

- (BOOL)hasDealtPath {
    return [[self class] isLegalPath:_dealtPath];
}

+ (UIImage *)imageNameWithItem:(HsFileBrowerItem *)item {
    if (item.isDir) {
        return [NSBundle hs_imageNamed:@"file_dir"];
    } else {
        NSString *imageName = [HsFileBrowerManager imageNameWithType:item.typeString];
        return [NSBundle hs_imageNamed:imageName];
    }
}

+ (NSString *)imageNameWithType:(NSString *)typeString {
    static dispatch_once_t onceToken;
    static NSDictionary *HsFileBrowerItemCellDictionary;
    dispatch_once(&onceToken, ^{
        if (!HsFileBrowerItemCellDictionary) {
            HsFileBrowerItemCellDictionary = @{
                // plist
                @"plist" : @"file_p",
                // text
                @"txt" : @"file_t",
                @"doc" : @"file_w",
                // video
                @"mp4" : @"file_video",
                @"rm" : @"file_video",
                @"rmvb" : @"file_video",
                @"flv" : @"file_video",
                @"avi" : @"file_video",
                // audio
                @"mp3" : @"file_audio",
                @"pcm" : @"file_audio",
                @"wav" : @"file_audio",
                @"wam" : @"file_audio",
                // img
                @"png" : @"file_img",
                @"jpg" : @"file_img",
                @"jpeg" : @"file_img",
            };
            
        };
    });
    if (!typeString || typeString.length == 0) {
        return @"file_unknown";
    }
    NSString *imageName = HsFileBrowerItemCellDictionary[typeString];
    if (!imageName) {
        imageName = @"file_unknown";
    }
    return imageName;
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
        HsFileBrowerItem *childItem = [[HsFileBrowerItem alloc] initWithPath:childPath name:content attributes:attributes parent:parent];
        [items addObject:childItem];
    }
    return items;
}


/// MARK: deal with path

/// 检查路径是否有效
/// @param path 文件路径
+ (BOOL)isLegalPath:(NSString *)path {
    if (!path || path.length == 0) {
        return NO;
    }
    return YES;
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
    if (![self isLegalPath:path]) return;
    [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

/// 重命名文件
/// @param path 文件路径
/// @param error 错误
+ (void)renameItemAtPath:(NSString *)path error:(NSError **)error {
    if (![self isLegalPath:path]) return;

}

/// 记录待处理文件路径，由于粘贴、移动等
/// @param path 文件路径
+ (void)dealWithPath:(NSString *)path {
    [HsFileBrowerManager manager].dealtPath = path;
}

/// 粘贴待处理文件
/// @param toPath 目标路径
/// @param error 错误
+ (void)pasteToPath:(NSString *)toPath error:(NSError **)error {
    NSString *path = [HsFileBrowerManager manager].dealtPath;
    if (![self isLegalPath:path]) return;
    [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:error];
}

/// 复制文件
/// @param path 原路径
/// @param toPath 目标路径
/// @param error 错误
+ (void)copyAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error {
    [self dealWithPath:path];
    if (![self isLegalPath:path]) return;
    [self pasteToPath:path error:error];
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

+ (void)removeItem:(HsFileBrowerItem *)item error:(NSError **)error {
    [self removeItemAtPath:item.path error:error];
}

+ (void)renameItem:(HsFileBrowerItem *)item error:(NSError **)error {
    [self renameItemAtPath:item.path error:error];
}

+ (void)copyItem:(HsFileBrowerItem *)item {
    [self dealWithPath:item.path];
}

/// MARK: -

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

+ (NSString *)sizeStringFromSize:(long long)size {
    static const long long rank = 1024;
    long long s = size;
    int i = -1;
    while (s) {
        i++;
        s /= rank;
    }
    if (i == -1) i = 0;
    static char *array[] = {"B", "KB", "MB", "GB", "TB", nil};
    return [NSString stringWithFormat:@"%lld %s", s, array[i]];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)massage fromController:(UIViewController *)controller {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:massage preferredStyle:UIAlertControllerStyleAlert];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
