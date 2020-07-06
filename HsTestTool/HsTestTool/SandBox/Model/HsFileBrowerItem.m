//
//  HsFileBrowerItem.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/28.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsFileBrowerItem.h"
#import "HsFileBrowerManager.h"

@interface HsFileBrowerItem ()

@end

@implementation HsFileBrowerItem

- (instancetype)initWithPath:(NSString *)path name:(NSString *)name attributes:(NSDictionary *)attributes {
    return [self initWithPath:path name:name attributes:attributes parent:nil];
}

- (instancetype)initWithPath:(NSString *)path name:(NSString *)name attributes:(NSDictionary *)attributes parent:(HsFileBrowerItem *)parent {
    if (self = [super init]) {
        _path = [path copy];
        _name = [name copy];
        _attributes = [attributes copy];
        _parent = parent;
        _isDir = [NSFileTypeDirectory isEqualToString:_attributes[NSFileType]];
    }
    return self;
}

- (NSString *)modificationDate {
    NSDate *date = _attributes[NSFileModificationDate];
    NSString *dateString = date.description;
    if (!dateString) {
        dateString = @"";
    } else if (dateString.length > 19) {
        dateString = [dateString substringToIndex:19];
    }
    return dateString;
}

- (NSString *)detailText {
    NSString *date = _attributes[NSFileModificationDate];
    return [NSString stringWithFormat:@"上次修改 \n%@", date];
}

- (NSString *)typeString {
    return _attributes.fileType;
//    NSArray *array = [_name componentsSeparatedByString:@"."];
//    if (array.count >= 2) {
//        return array.lastObject;
//    }
//    return @"";
}

- (NSString *)sizeString {
    return [HsFileBrowerManager sizeStringFromSize:_attributes.fileSize];
}

- (NSString *)createDateString {
    return [HsFileBrowerManager stringFromDateByDateAndTime:_attributes.fileCreationDate];
}

- (NSString *)modifyDateString {
    return [HsFileBrowerManager stringFromDateByDateAndTime:_attributes.fileModificationDate];
}

- (NSString *)lastOpenDateString {
    return [HsFileBrowerManager stringFromDateByDateAndTime:_attributes.fileModificationDate];
}


@end

/*
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileType;
 FOUNDATION_EXPORT NSFileAttributeType const NSFileTypeDirectory;
 FOUNDATION_EXPORT NSFileAttributeType const NSFileTypeRegular;
 FOUNDATION_EXPORT NSFileAttributeType const NSFileTypeSymbolicLink;
 FOUNDATION_EXPORT NSFileAttributeType const NSFileTypeSocket;
 FOUNDATION_EXPORT NSFileAttributeType const NSFileTypeCharacterSpecial;
 FOUNDATION_EXPORT NSFileAttributeType const NSFileTypeBlockSpecial;
 FOUNDATION_EXPORT NSFileAttributeType const NSFileTypeUnknown;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileSize;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileModificationDate;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileReferenceCount;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileDeviceIdentifier;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileOwnerAccountName;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileGroupOwnerAccountName;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFilePosixPermissions;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileSystemNumber;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileSystemFileNumber;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileExtensionHidden;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileHFSCreatorCode;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileHFSTypeCode;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileImmutable;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileAppendOnly;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileCreationDate;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileOwnerAccountID;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileGroupOwnerAccountID;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileBusy;
 FOUNDATION_EXPORT NSFileAttributeKey const NSFileProtectionKey API_AVAILABLE(ios(4.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);
 
 */
