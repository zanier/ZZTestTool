//
//  ZZFileBrowerHeader.h
//  ZZTestTool
//
//  Created by zanier on 2020/7/9.
//  Copyright © 2020 zanier. All rights reserved.
//

#ifndef ZZFileBrowerHeader_h
#define ZZFileBrowerHeader_h

#import <Foundation/Foundation.h>
#ifdef ZZTESTTOOL_NEED_QUICKLOOK
#import <QuickLook/QuickLook.h>
#endif

typedef NS_ENUM(NSUInteger, ZZFileBrowerFileType) {
    ZZFileBrowerFileTypeUnknown = 0,
    ZZFileBrowerFileTypeDirectory,
    // Image
    ZZFileBrowerFileTypeJPG, ZZFileBrowerFileTypePNG, ZZFileBrowerFileTypeGIF, ZZFileBrowerFileTypeSVG, ZZFileBrowerFileTypeBMP, ZZFileBrowerFileTypeTIF,
    // Audio
    ZZFileBrowerFileTypeMP3, ZZFileBrowerFileTypeAAC, ZZFileBrowerFileTypeWAV, ZZFileBrowerFileTypeOGG,
    // Video
    ZZFileBrowerFileTypeMP4, ZZFileBrowerFileTypeAVI, ZZFileBrowerFileTypeFLV, ZZFileBrowerFileTypeMIDI, ZZFileBrowerFileTypeMOV, ZZFileBrowerFileTypeMPG, ZZFileBrowerFileTypeWMV,
    // Apple
    ZZFileBrowerFileTypeNSBundle, ZZFileBrowerFileTypeDMG, ZZFileBrowerFileTypeIPA, ZZFileBrowerFileTypeNumbers, ZZFileBrowerFileTypePages, ZZFileBrowerFileTypeKeynote,
    // Google
    ZZFileBrowerFileTypeAPK,
    // Microsoft
    ZZFileBrowerFileTypeWord, ZZFileBrowerFileTypeExcel, ZZFileBrowerFileTypePPT, ZZFileBrowerFileTypeEXE, ZZFileBrowerFileTypeDLL,
    // Document
    ZZFileBrowerFileTypeTXT, ZZFileBrowerFileTypeRTF, ZZFileBrowerFileTypePDF, ZZFileBrowerFileTypeZIP, ZZFileBrowerFileType7z, ZZFileBrowerFileTypeCVS, ZZFileBrowerFileTypeMD,
    // Programming
    ZZFileBrowerFileTypeSwift, ZZFileBrowerFileTypeJava, ZZFileBrowerFileTypeC, ZZFileBrowerFileTypeCPP, ZZFileBrowerFileTypePHP,
    ZZFileBrowerFileTypeJSON, ZZFileBrowerFileTypePList, ZZFileBrowerFileTypeXML, ZZFileBrowerFileTypeDatabase,
    ZZFileBrowerFileTypeJS, ZZFileBrowerFileTypeHTML, ZZFileBrowerFileTypeCSS,
    ZZFileBrowerFileTypeBIN, ZZFileBrowerFileTypeDat, ZZFileBrowerFileTypeSQL, ZZFileBrowerFileTypeJAR,
    // Adobe
    ZZFileBrowerFileTypeFlash, ZZFileBrowerFileTypePSD, ZZFileBrowerFileTypeEPS,
    // Other
    ZZFileBrowerFileTypeTTF, ZZFileBrowerFileTypeTorrent,
};

static NSString *const ZZFileBrowerActionPage_Select    = @"选择";
static NSString *const ZZFileBrowerActionPage_Mkdir     = @"新建文件夹";
static NSString *const ZZFileBrowerActionPage_SortByName    = @"名称";
static NSString *const ZZFileBrowerActionPage_SortByDate    = @"日期";
static NSString *const ZZFileBrowerActionPage_SortBySize    = @"大小";
static NSString *const ZZFileBrowerActionPage_SortByType    = @"种类";

static NSString *const ZZFileBrowerActionPage_Copy      = @"拷贝";
static NSString *const ZZFileBrowerActionPage_Duplicate = @"复制";
static NSString *const ZZFileBrowerActionPage_Move      = @"移动";
static NSString *const ZZFileBrowerActionPage_Delete    = @"删除";
static NSString *const ZZFileBrowerActionPage_Rename    = @"重命名";
static NSString *const ZZFileBrowerActionPage_Brief     = @"简介";
static NSString *const ZZFileBrowerActionPage_Share     = @"共享";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

/// 通过文件扩展名获取文件类型
/// @param extension 文件扩展名
static ZZFileBrowerFileType ZZFileTypeWithExtension(NSString *extension) {
    ZZFileBrowerFileType type = ZZFileBrowerFileTypeUnknown;
    if (!extension || ![extension isKindOfClass:[NSString class]] || extension.length == 0) {
        return type;
    }
    // Image
    if ([extension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeJPG;
    } else if ([extension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypePNG;
    } else if ([extension compare:@"gif" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeGIF;
    } else if ([extension compare:@"svg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeSVG;
    } else if ([extension compare:@"bmp" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeBMP;
    } else if ([extension compare:@"tif" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeTIF;
    }
    /// - Audio
    else if ([extension compare:@"mp3" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeMP3;
    } else if ([extension compare:@"aac" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeAAC;
    } else if ([extension compare:@"wav" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeWAV;
    } else if ([extension compare:@"ogg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeOGG;
    }
    /// - Video
    else if ([extension compare:@"mp4" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeMP4;
    } else if ([extension compare:@"avi" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeAVI;
    } else if ([extension compare:@"flv" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeFLV;
    } else if ([extension compare:@"midi" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeMIDI;
    } else if ([extension compare:@"mov" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeMOV;
    } else if ([extension compare:@"mpg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeMPG;
    } else if ([extension compare:@"wmv" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeWMV;
    }
    /// - Apple
    else if ([extension compare:@"bundle" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeNSBundle;
    } else if ([extension compare:@"dmg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeDMG;
    } else if ([extension compare:@"ipa" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeIPA;
    } else if ([extension compare:@"numbers" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeNumbers;
    } else if ([extension compare:@"pages" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypePages;
    } else if ([extension compare:@"key" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeKeynote;
    }
    /// - Google
    else if ([extension compare:@"apk" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeAPK;
    }
    /// - Microsoft
    else if ([extension compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
             [extension compare:@"docx" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeWord;
    } else if ([extension compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
               [extension compare:@"xlsx" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeExcel;
    } else if ([extension compare:@"ppt" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
               [extension compare:@"pptx" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypePPT;
    } else if ([extension compare:@"exe" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeEXE;
    } else if ([extension compare:@"dll" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeDLL;
    }
    /// - Document
    else if ([extension compare:@"txt" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeTXT;
    } else if ([extension compare:@"rtf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeRTF;
    } else if ([extension compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypePDF;
    } else if ([extension compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeZIP;
    } else if ([extension compare:@"7z" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileType7z;
    } else if ([extension compare:@"cvs" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeCVS;
    } else if ([extension compare:@"md" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeMD;
    }
    /// - Programming
    else if ([extension compare:@"swift" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeSwift;
    } else if ([extension compare:@"java" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeJava;
    } else if ([extension compare:@"c" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeC;
    } else if ([extension compare:@"cpp" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeCPP;
    } else if ([extension compare:@"php" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypePHP;
    } else if ([extension compare:@"json" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeJSON;
    } else if ([extension compare:@"plist" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypePList;
    } else if ([extension compare:@"xml" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeXML;
    } else if ([extension compare:@"db" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeDatabase;
    } else if ([extension compare:@"js" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeJS;
    } else if ([extension compare:@"html" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeHTML;
    } else if ([extension compare:@"css" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeCSS;
    } else if ([extension compare:@"bin" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeBIN;
    } else if ([extension compare:@"dat" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeDat;
    } else if ([extension compare:@"sql" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeSQL;
    } else if ([extension compare:@"jar" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeJAR;
    }
    /// - Adobe
    else if ([extension compare:@"psd" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypePSD;
    }
    else if ([extension compare:@"eps" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeEPS;
    }
    /// - Other
    else if ([extension compare:@"ttf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeTTF;
    } else if ([extension compare:@"torrent" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = ZZFileBrowerFileTypeTorrent;
    }
    return type;
}

/// 获取文件类型对应的图片名
/// @param type 文件类型
static NSString *ZZImageNameWithType(ZZFileBrowerFileType type) {
    NSString *typeImageName;
    switch (type) {
        case ZZFileBrowerFileTypeUnknown: typeImageName = @"icon_file_type_default"; break;
        case ZZFileBrowerFileTypeDirectory: typeImageName = @"icon_file_type_folder_not_empty"; break;
            // Image
        case ZZFileBrowerFileTypeJPG: typeImageName = @"icon_file_type_jpg"; break;
        case ZZFileBrowerFileTypePNG: typeImageName = @"icon_file_type_png"; break;
        case ZZFileBrowerFileTypeGIF: typeImageName = @"icon_file_type_gif"; break;
        case ZZFileBrowerFileTypeSVG: typeImageName = @"icon_file_type_svg"; break;
        case ZZFileBrowerFileTypeBMP: typeImageName = @"icon_file_type_bmp"; break;
        case ZZFileBrowerFileTypeTIF: typeImageName = @"icon_file_type_tif"; break;
            // Audio
        case ZZFileBrowerFileTypeMP3: typeImageName = @"icon_file_type_mp3"; break;
        case ZZFileBrowerFileTypeAAC: typeImageName = @"icon_file_type_aac"; break;
        case ZZFileBrowerFileTypeWAV: typeImageName = @"icon_file_type_wav"; break;
        case ZZFileBrowerFileTypeOGG: typeImageName = @"icon_file_type_ogg"; break;
            // Video
        case ZZFileBrowerFileTypeMP4: typeImageName = @"icon_file_type_mp4"; break;
        case ZZFileBrowerFileTypeAVI: typeImageName = @"icon_file_type_avi"; break;
        case ZZFileBrowerFileTypeFLV: typeImageName = @"icon_file_type_flv"; break;
        case ZZFileBrowerFileTypeMIDI: typeImageName = @"icon_file_type_midi"; break;
        case ZZFileBrowerFileTypeMOV: typeImageName = @"icon_file_type_mov"; break;
        case ZZFileBrowerFileTypeMPG: typeImageName = @"icon_file_type_mpg"; break;
        case ZZFileBrowerFileTypeWMV: typeImageName = @"icon_file_type_wmv"; break;
            // Apple
        case ZZFileBrowerFileTypeNSBundle: typeImageName = @"icon_file_type_bundle"; break;
        case ZZFileBrowerFileTypeDMG: typeImageName = @"icon_file_type_dmg"; break;
        case ZZFileBrowerFileTypeIPA: typeImageName = @"icon_file_type_ipa"; break;
        case ZZFileBrowerFileTypeNumbers: typeImageName = @"icon_file_type_numbers"; break;
        case ZZFileBrowerFileTypePages: typeImageName = @"icon_file_type_pages"; break;
        case ZZFileBrowerFileTypeKeynote: typeImageName = @"icon_file_type_keynote"; break;
            // Google
        case ZZFileBrowerFileTypeAPK: typeImageName = @"icon_file_type_apk"; break;
            // Microsoft
        case ZZFileBrowerFileTypeWord: typeImageName = @"icon_file_type_doc"; break;
        case ZZFileBrowerFileTypeExcel: typeImageName = @"icon_file_type_xls"; break;
        case ZZFileBrowerFileTypePPT: typeImageName = @"icon_file_type_ppt"; break;
        case ZZFileBrowerFileTypeEXE: typeImageName = @"icon_file_type_exe"; break;
        case ZZFileBrowerFileTypeDLL: typeImageName = @"icon_file_type_dll"; break;
            // Document
        case ZZFileBrowerFileTypeTXT: typeImageName = @"icon_file_type_txt"; break;
        case ZZFileBrowerFileTypeRTF: typeImageName = @"icon_file_type_rtf"; break;
        case ZZFileBrowerFileTypePDF: typeImageName = @"icon_file_type_pdf"; break;
        case ZZFileBrowerFileTypeZIP: typeImageName = @"icon_file_type_zip"; break;
        case ZZFileBrowerFileType7z: typeImageName = @"icon_file_type_7z"; break;
        case ZZFileBrowerFileTypeCVS: typeImageName = @"icon_file_type_cvs"; break;
        case ZZFileBrowerFileTypeMD: typeImageName = @"icon_file_type_md"; break;
            // Programming
        case ZZFileBrowerFileTypeSwift: typeImageName = @"icon_file_type_swift"; break;
        case ZZFileBrowerFileTypeJava: typeImageName = @"icon_file_type_java"; break;
        case ZZFileBrowerFileTypeC: typeImageName = @"icon_file_type_c"; break;
        case ZZFileBrowerFileTypeCPP: typeImageName = @"icon_file_type_cpp"; break;
        case ZZFileBrowerFileTypePHP: typeImageName = @"icon_file_type_php"; break;
        case ZZFileBrowerFileTypeJSON: typeImageName = @"icon_file_type_json"; break;
        case ZZFileBrowerFileTypePList: typeImageName = @"icon_file_type_plist"; break;
        case ZZFileBrowerFileTypeXML: typeImageName = @"icon_file_type_xml"; break;
        case ZZFileBrowerFileTypeDatabase: typeImageName = @"icon_file_type_db"; break;
        case ZZFileBrowerFileTypeJS: typeImageName = @"icon_file_type_js"; break;
        case ZZFileBrowerFileTypeHTML: typeImageName = @"icon_file_type_html"; break;
        case ZZFileBrowerFileTypeCSS: typeImageName = @"icon_file_type_css"; break;
        case ZZFileBrowerFileTypeBIN: typeImageName = @"icon_file_type_bin"; break;
        case ZZFileBrowerFileTypeDat: typeImageName = @"icon_file_type_dat"; break;
        case ZZFileBrowerFileTypeSQL: typeImageName = @"icon_file_type_sql"; break;
        case ZZFileBrowerFileTypeJAR: typeImageName = @"icon_file_type_jar"; break;
            // Adobe
        case ZZFileBrowerFileTypeFlash: typeImageName = @"icon_file_type_fla"; break;
        case ZZFileBrowerFileTypePSD: typeImageName = @"icon_file_type_psd"; break;
        case ZZFileBrowerFileTypeEPS: typeImageName = @"icon_file_type_eps"; break;
            // Other
        case ZZFileBrowerFileTypeTTF: typeImageName = @"icon_file_type_ttf"; break;
        case ZZFileBrowerFileTypeTorrent: typeImageName = @"icon_file_type_torrent"; break;
    }
    return typeImageName;
}

/// 操作图标
/// @param text 操作字段
static NSString *ZZActionImageNameWithActionText(NSString *text) {
    NSString *imageName = nil;
    if ([ZZFileBrowerActionPage_Copy isEqualToString:text]) {
        imageName = @"icon_action_paste@2x";
    } else if ([ZZFileBrowerActionPage_Duplicate isEqualToString:text]) {
        imageName = @"icon_action_copy@2x";
    } else if ([ZZFileBrowerActionPage_Move isEqualToString:text]) {
        imageName = @"icon_action_move@2x";
    } else if ([ZZFileBrowerActionPage_Delete isEqualToString:text]) {
        imageName = @"icon_action_delete@2x";
    } else if ([ZZFileBrowerActionPage_Brief isEqualToString:text]) {
        imageName = @"icon_action_info@2x";
    } else if ([ZZFileBrowerActionPage_Rename isEqualToString:text]) {
        imageName = @"icon_action_rename@2x";
    } else if ([ZZFileBrowerActionPage_Share isEqualToString:text]) {
        imageName = @"icon_action_out@2x";
    } else if ([ZZFileBrowerActionPage_Select isEqualToString:text]) {
        imageName = @"icon_action_select@2x";
    } else if ([ZZFileBrowerActionPage_Mkdir isEqualToString:text]) {
        imageName = @"icon_action_mkdir@2x";
    } else if ([ZZFileBrowerActionPage_SortByName isEqualToString:text]) {
    } else if ([ZZFileBrowerActionPage_SortByDate isEqualToString:text]) {
    } else if ([ZZFileBrowerActionPage_SortBySize isEqualToString:text]) {
    } else if ([ZZFileBrowerActionPage_SortByType isEqualToString:text]) {
    }
    return imageName;
}

#pragma clang diagnostic pop

#ifdef ZZTESTTOOL_NEED_QUICKLOOK
@protocol ZZQLPreviewControllerDataSource <QLPreviewControllerDataSource>
@end
#else
@protocol ZZQLPreviewControllerDataSource
@end
#endif

#endif /* ZZFileBrowerHeader_h */
