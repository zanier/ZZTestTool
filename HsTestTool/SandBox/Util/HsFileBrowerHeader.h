//
//  HsFileBrowerHeader.h
//  HsTestTool
//
//  Created by handsome on 2020/7/9.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#ifndef HsFileBrowerHeader_h
#define HsFileBrowerHeader_h

#import <Foundation/Foundation.h>
#ifdef HSTESTTOOL_NEED_QUICKLOOK
#import <QuickLook/QuickLook.h>
#endif

typedef NS_ENUM(NSUInteger, HsFileBrowerFileType) {
    HsFileBrowerFileTypeUnknown = 0,
    HsFileBrowerFileTypeDirectory,
    // Image
    HsFileBrowerFileTypeJPG, HsFileBrowerFileTypePNG, HsFileBrowerFileTypeGIF, HsFileBrowerFileTypeSVG, HsFileBrowerFileTypeBMP, HsFileBrowerFileTypeTIF,
    // Audio
    HsFileBrowerFileTypeMP3, HsFileBrowerFileTypeAAC, HsFileBrowerFileTypeWAV, HsFileBrowerFileTypeOGG,
    // Video
    HsFileBrowerFileTypeMP4, HsFileBrowerFileTypeAVI, HsFileBrowerFileTypeFLV, HsFileBrowerFileTypeMIDI, HsFileBrowerFileTypeMOV, HsFileBrowerFileTypeMPG, HsFileBrowerFileTypeWMV,
    // Apple
    HsFileBrowerFileTypeNSBundle, HsFileBrowerFileTypeDMG, HsFileBrowerFileTypeIPA, HsFileBrowerFileTypeNumbers, HsFileBrowerFileTypePages, HsFileBrowerFileTypeKeynote,
    // Google
    HsFileBrowerFileTypeAPK,
    // Microsoft
    HsFileBrowerFileTypeWord, HsFileBrowerFileTypeExcel, HsFileBrowerFileTypePPT, HsFileBrowerFileTypeEXE, HsFileBrowerFileTypeDLL,
    // Document
    HsFileBrowerFileTypeTXT, HsFileBrowerFileTypeRTF, HsFileBrowerFileTypePDF, HsFileBrowerFileTypeZIP, HsFileBrowerFileType7z, HsFileBrowerFileTypeCVS, HsFileBrowerFileTypeMD,
    // Programming
    HsFileBrowerFileTypeSwift, HsFileBrowerFileTypeJava, HsFileBrowerFileTypeC, HsFileBrowerFileTypeCPP, HsFileBrowerFileTypePHP,
    HsFileBrowerFileTypeJSON, HsFileBrowerFileTypePList, HsFileBrowerFileTypeXML, HsFileBrowerFileTypeDatabase,
    HsFileBrowerFileTypeJS, HsFileBrowerFileTypeHTML, HsFileBrowerFileTypeCSS,
    HsFileBrowerFileTypeBIN, HsFileBrowerFileTypeDat, HsFileBrowerFileTypeSQL, HsFileBrowerFileTypeJAR,
    // Adobe
    HsFileBrowerFileTypeFlash, HsFileBrowerFileTypePSD, HsFileBrowerFileTypeEPS,
    // Other
    HsFileBrowerFileTypeTTF, HsFileBrowerFileTypeTorrent,
};

static NSString *const HsFileBrowerActionPage_Select    = @"选择";
static NSString *const HsFileBrowerActionPage_Mkdir     = @"新建文件夹";
static NSString *const HsFileBrowerActionPage_SortByName    = @"名称";
static NSString *const HsFileBrowerActionPage_SortByDate    = @"日期";
static NSString *const HsFileBrowerActionPage_SortBySize    = @"大小";
static NSString *const HsFileBrowerActionPage_SortByType    = @"种类";

static NSString *const HsFileBrowerActionPage_Copy      = @"拷贝";
static NSString *const HsFileBrowerActionPage_Duplicate = @"复制";
static NSString *const HsFileBrowerActionPage_Move      = @"移动";
static NSString *const HsFileBrowerActionPage_Delete    = @"删除";
static NSString *const HsFileBrowerActionPage_Rename    = @"重命名";
static NSString *const HsFileBrowerActionPage_Brief     = @"简介";
static NSString *const HsFileBrowerActionPage_Share     = @"共享";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

/// 通过文件扩展名获取文件类型
/// @param extension 文件扩展名
static HsFileBrowerFileType HsFileTypeWithExtension(NSString *extension) {
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
    else if ([extension compare:@"bundle" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        type = HsFileBrowerFileTypeNSBundle;
    } else if ([extension compare:@"dmg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
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

/// 获取文件类型对应的图片名
/// @param type 文件类型
static NSString *HsImageNameWithType(HsFileBrowerFileType type) {
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
        case HsFileBrowerFileTypeNSBundle: typeImageName = @"icon_file_type_bundle"; break;
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

/// 操作图标
/// @param text 操作字段
static NSString *HsActionImageNameWithActionText(NSString *text) {
    NSString *imageName = nil;
    if ([HsFileBrowerActionPage_Copy isEqualToString:text]) {
        imageName = @"icon_action_paste@2x";
    } else if ([HsFileBrowerActionPage_Duplicate isEqualToString:text]) {
        imageName = @"icon_action_copy@2x";
    } else if ([HsFileBrowerActionPage_Move isEqualToString:text]) {
        imageName = @"icon_action_move@2x";
    } else if ([HsFileBrowerActionPage_Delete isEqualToString:text]) {
        imageName = @"icon_action_delete@2x";
    } else if ([HsFileBrowerActionPage_Brief isEqualToString:text]) {
        imageName = @"icon_action_info@2x";
    } else if ([HsFileBrowerActionPage_Rename isEqualToString:text]) {
        imageName = @"icon_action_rename@2x";
    } else if ([HsFileBrowerActionPage_Share isEqualToString:text]) {
        imageName = @"icon_action_out@2x";
    } else if ([HsFileBrowerActionPage_Select isEqualToString:text]) {
        imageName = @"icon_action_select@2x";
    } else if ([HsFileBrowerActionPage_Mkdir isEqualToString:text]) {
        imageName = @"icon_action_mkdir@2x";
    } else if ([HsFileBrowerActionPage_SortByName isEqualToString:text]) {
    } else if ([HsFileBrowerActionPage_SortByDate isEqualToString:text]) {
    } else if ([HsFileBrowerActionPage_SortBySize isEqualToString:text]) {
    } else if ([HsFileBrowerActionPage_SortByType isEqualToString:text]) {
    }
    return imageName;
}

#pragma clang diagnostic pop

#ifdef HSTESTTOOL_NEED_QUICKLOOK
@protocol HsQLPreviewControllerDataSource <QLPreviewControllerDataSource>
@end
#else
@protocol HsQLPreviewControllerDataSource
@end
#endif

#endif /* HsFileBrowerHeader_h */
