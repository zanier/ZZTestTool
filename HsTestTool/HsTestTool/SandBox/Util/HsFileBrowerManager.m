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

//+ (UIImage *)imageNameWithItem:(HsFileBrowerItem *)item {
//    if (item.isDir) {
//        return [NSBundle hs_imageNamed:@"file_dir"];
//    } else {
//        NSString *imageName = [HsFileBrowerManager imageNameWithType:item.typeString];
//        return [NSBundle hs_imageNamed:imageName];
//    }
//}

//+ (NSString *)imageNameWithType:(NSString *)typeString {
//    static dispatch_once_t onceToken;
//    static NSDictionary *HsFileBrowerItemCellDictionary;
//    dispatch_once(&onceToken, ^{
//        if (!HsFileBrowerItemCellDictionary) {
//            HsFileBrowerItemCellDictionary = @{
//                // plist
//                @"plist" : @"file_p",
//                // text
//                @"txt" : @"file_t",
//                @"doc" : @"file_w",
//                // video
//                @"mp4" : @"file_video",
//                @"rm" : @"file_video",
//                @"rmvb" : @"file_video",
//                @"flv" : @"file_video",
//                @"avi" : @"file_video",
//                // audio
//                @"mp3" : @"file_audio",
//                @"pcm" : @"file_audio",
//                @"wav" : @"file_audio",
//                @"wam" : @"file_audio",
//                // img
//                @"png" : @"file_img",
//                @"jpg" : @"file_img",
//                @"jpeg" : @"file_img",
//            };
//
//        };
//    });
//    if (!typeString || typeString.length == 0) {
//        return @"file_unknown";
//    }
//    NSString *imageName = HsFileBrowerItemCellDictionary[typeString];
//    if (!imageName) {
//        imageName = @"file_unknown";
//    }
//    return imageName;
//}

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
        HsFileBrowerItem *childItem = [[HsFileBrowerItem alloc] initWithPath:childPath];
        childItem.attributes = attributes;
        childItem.parent = parent;
        [items addObject:childItem];
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
    NSString *regex = @"[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\\.?";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:path];
}

/// 判断文件名是否合法
+ (BOOL)isLegalFileName:(NSString *)name {
    if (!name || ![name isKindOfClass:[NSString class]] || name.length == 0) return NO;
    NSString *regex = @"^[\u4E00-\u9FA5A-Za-z0-9_]+$";
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

+ (NSString *)imageNameWithType:(HsFileBrowerFileType)type {
    NSString *typeImageName;
    switch (type) {
        case HsFileBrowerFileTypeUnknown: typeImageName = @"icon_file_type_default"; break;
        case HsFileBrowerFileTypeDirectory: typeImageName = @"icon_file_type_folder_not_empty"; break;
            // Image
        case HsFileBrowerFileTypeJPG: typeImageName = @"icon_file_type_jpg"; break;
        case HsFileBrowerFileTypePNG: typeImageName = @"icon_file_type_png"; break;
        case HsFileBrowerFileTypeGIF: typeImageName = @"icon_file_type_gif"; break;
        case HsFileBrowerFileTypeSVG: typeImageName = @"icon_file_type_svg"; break;
        case HsFileBrowerFileTypeBMP: typeImageName = @"icon_file_type_bmp"; break;
        case HsFileBrowerFileTypeTIF: typeImageName = @"icon_file_type_tif"; break;
            // Audio
        case HsFileBrowerFileTypeMP3: typeImageName = @"icon_file_type_mp3"; break;
        case HsFileBrowerFileTypeAAC: typeImageName = @"icon_file_type_aac"; break;
        case HsFileBrowerFileTypeWAV: typeImageName = @"icon_file_type_wav"; break;
        case HsFileBrowerFileTypeOGG: typeImageName = @"icon_file_type_ogg"; break;
            // Video
        case HsFileBrowerFileTypeMP4: typeImageName = @"icon_file_type_mp4"; break;
        case HsFileBrowerFileTypeAVI: typeImageName = @"icon_file_type_avi"; break;
        case HsFileBrowerFileTypeFLV: typeImageName = @"icon_file_type_flv"; break;
        case HsFileBrowerFileTypeMIDI: typeImageName = @"icon_file_type_midi"; break;
        case HsFileBrowerFileTypeMOV: typeImageName = @"icon_file_type_mov"; break;
        case HsFileBrowerFileTypeMPG: typeImageName = @"icon_file_type_mpg"; break;
        case HsFileBrowerFileTypeWMV: typeImageName = @"icon_file_type_wmv"; break;
            // Apple
        case HsFileBrowerFileTypeDMG: typeImageName = @"icon_file_type_dmg"; break;
        case HsFileBrowerFileTypeIPA: typeImageName = @"icon_file_type_ipa"; break;
        case HsFileBrowerFileTypeNumbers: typeImageName = @"icon_file_type_numbers"; break;
        case HsFileBrowerFileTypePages: typeImageName = @"icon_file_type_pages"; break;
        case HsFileBrowerFileTypeKeynote: typeImageName = @"icon_file_type_keynote"; break;
            // Google
        case HsFileBrowerFileTypeAPK: typeImageName = @"icon_file_type_apk"; break;
            // Microsoft
        case HsFileBrowerFileTypeWord: typeImageName = @"icon_file_type_doc"; break;
        case HsFileBrowerFileTypeExcel: typeImageName = @"icon_file_type_xls"; break;
        case HsFileBrowerFileTypePPT: typeImageName = @"icon_file_type_ppt"; break;
        case HsFileBrowerFileTypeEXE: typeImageName = @"icon_file_type_exe"; break;
        case HsFileBrowerFileTypeDLL: typeImageName = @"icon_file_type_dll"; break;
            // Document
        case HsFileBrowerFileTypeTXT: typeImageName = @"icon_file_type_txt"; break;
        case HsFileBrowerFileTypeRTF: typeImageName = @"icon_file_type_rtf"; break;
        case HsFileBrowerFileTypePDF: typeImageName = @"icon_file_type_pdf"; break;
        case HsFileBrowerFileTypeZIP: typeImageName = @"icon_file_type_zip"; break;
        case HsFileBrowerFileType7z: typeImageName = @"icon_file_type_7z"; break;
        case HsFileBrowerFileTypeCVS: typeImageName = @"icon_file_type_cvs"; break;
        case HsFileBrowerFileTypeMD: typeImageName = @"icon_file_type_md"; break;
            // Programming
        case HsFileBrowerFileTypeSwift: typeImageName = @"icon_file_type_swift"; break;
        case HsFileBrowerFileTypeJava: typeImageName = @"icon_file_type_java"; break;
        case HsFileBrowerFileTypeC: typeImageName = @"icon_file_type_c"; break;
        case HsFileBrowerFileTypeCPP: typeImageName = @"icon_file_type_cpp"; break;
        case HsFileBrowerFileTypePHP: typeImageName = @"icon_file_type_php"; break;
        case HsFileBrowerFileTypeJSON: typeImageName = @"icon_file_type_json"; break;
        case HsFileBrowerFileTypePList: typeImageName = @"icon_file_type_plist"; break;
        case HsFileBrowerFileTypeXML: typeImageName = @"icon_file_type_xml"; break;
        case HsFileBrowerFileTypeDatabase: typeImageName = @"icon_file_type_db"; break;
        case HsFileBrowerFileTypeJS: typeImageName = @"icon_file_type_js"; break;
        case HsFileBrowerFileTypeHTML: typeImageName = @"icon_file_type_html"; break;
        case HsFileBrowerFileTypeCSS: typeImageName = @"icon_file_type_css"; break;
        case HsFileBrowerFileTypeBIN: typeImageName = @"icon_file_type_bin"; break;
        case HsFileBrowerFileTypeDat: typeImageName = @"icon_file_type_dat"; break;
        case HsFileBrowerFileTypeSQL: typeImageName = @"icon_file_type_sql"; break;
        case HsFileBrowerFileTypeJAR: typeImageName = @"icon_file_type_jar"; break;
            // Adobe
        case HsFileBrowerFileTypeFlash: typeImageName = @"icon_file_type_fla"; break;
        case HsFileBrowerFileTypePSD: typeImageName = @"icon_file_type_psd"; break;
        case HsFileBrowerFileTypeEPS: typeImageName = @"icon_file_type_eps"; break;
            // Other
        case HsFileBrowerFileTypeTTF: typeImageName = @"icon_file_type_ttf"; break;
        case HsFileBrowerFileTypeTorrent: typeImageName = @"icon_file_type_torrent"; break;
    }
    return typeImageName;
}

+ (HsFileBrowerFileType)fileTypeWithExtension:(NSString *)extension {
    HsFileBrowerFileType type = HsFileBrowerFileTypeUnknown;
    if (!extension || ![extension isKindOfClass:[NSString class]] || extension.length == 0) {
        return type;
    }
    // Image
    if ([extension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeJPG;
    } else if ([extension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypePNG;
    } else if ([extension compare:@"gif" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeGIF;
    } else if ([extension compare:@"svg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeSVG;
    } else if ([extension compare:@"bmp" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeBMP;
    } else if ([extension compare:@"tif" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeTIF;
    }
    /// - Audio
    else if ([extension compare:@"mp3" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeMP3;
    } else if ([extension compare:@"aac" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeAAC;
    } else if ([extension compare:@"wav" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeWAV;
    } else if ([extension compare:@"ogg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeOGG;
    }
    /// - Video
    else if ([extension compare:@"mp4" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeMP4;
    } else if ([extension compare:@"avi" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeAVI;
    } else if ([extension compare:@"flv" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeFLV;
    } else if ([extension compare:@"midi" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeMIDI;
    } else if ([extension compare:@"mov" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeMOV;
    } else if ([extension compare:@"mpg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeMPG;
    } else if ([extension compare:@"wmv" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeWMV;
    }
    /// - Apple
    else if ([extension compare:@"dmg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeDMG;
    } else if ([extension compare:@"ipa" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeIPA;
    } else if ([extension compare:@"numbers" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeNumbers;
    } else if ([extension compare:@"pages" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypePages;
    } else if ([extension compare:@"key" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeKeynote;
    }
    /// - Google
    else if ([extension compare:@"apk" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeAPK;
    }
    /// - Microsoft
    else if ([extension compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
             [extension compare:@"docx" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeWord;
    } else if ([extension compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
               [extension compare:@"xlsx" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeExcel;
    } else if ([extension compare:@"ppt" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
               [extension compare:@"pptx" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypePPT;
    } else if ([extension compare:@"exe" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeEXE;
    } else if ([extension compare:@"dll" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeDLL;
    }
    /// - Document
    else if ([extension compare:@"txt" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeTXT;
    } else if ([extension compare:@"rtf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeRTF;
    } else if ([extension compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypePDF;
    } else if ([extension compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeZIP;
    } else if ([extension compare:@"7z" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileType7z;
    } else if ([extension compare:@"cvs" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeCVS;
    } else if ([extension compare:@"md" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeMD;
    }
    /// - Programming
    else if ([extension compare:@"swift" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeSwift;
    } else if ([extension compare:@"java" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeJava;
    } else if ([extension compare:@"c" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeC;
    } else if ([extension compare:@"cpp" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeCPP;
    } else if ([extension compare:@"php" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypePHP;
    } else if ([extension compare:@"json" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeJSON;
    } else if ([extension compare:@"plist" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypePList;
    } else if ([extension compare:@"xml" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeXML;
    } else if ([extension compare:@"db" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeDatabase;
    } else if ([extension compare:@"js" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeJS;
    } else if ([extension compare:@"html" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeHTML;
    } else if ([extension compare:@"css" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeCSS;
    } else if ([extension compare:@"bin" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeBIN;
    } else if ([extension compare:@"dat" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeDat;
    } else if ([extension compare:@"sql" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeSQL;
    } else if ([extension compare:@"jar" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeJAR;
    }
    /// - Adobe
    else if ([extension compare:@"psd" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypePSD;
    }
    else if ([extension compare:@"eps" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeEPS;
    }
    /// - Other
    else if ([extension compare:@"ttf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeTTF;
    } else if ([extension compare:@"torrent" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeTorrent;
    }
    
    return type;
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

@end
