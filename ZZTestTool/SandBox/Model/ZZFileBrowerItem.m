//
//  ZZFileBrowerItem.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/28.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZFileBrowerItem.h"
#import "ZZFileBrowerManager.h"

@interface ZZFileBrowerItem ()

@property (nonatomic, assign) ZZFileBrowerItemSortType sortType;

@end

@implementation ZZFileBrowerItem

/// MARK - init

- (instancetype)initWithPath:(NSString *)path {
    if (self = [super init]) {
        _path = [path copy];
        _name = path.lastPathComponent;
        _extension = [_name pathExtension];
        _type = ZZFileTypeWithExtension(_extension);
    }
    return self;
}

- (void)setAttributes:(NSDictionary *)attributes {
    _attributes = [attributes copy];
    if (!_type && [NSFileTypeDirectory isEqualToString:_attributes[NSFileType]]) {
        _type = ZZFileBrowerFileTypeDirectory;
    }
}

/// MARK: -

- (BOOL)isDir {
    return
    self.type == ZZFileBrowerFileTypeDirectory ||
    self.type == ZZFileBrowerFileTypeNSBundle;
}

- (BOOL)isImage {
    return
    self.type == ZZFileBrowerFileTypeJPG ||
    self.type == ZZFileBrowerFileTypePNG ||
    self.type == ZZFileBrowerFileTypeGIF ||
    self.type == ZZFileBrowerFileTypeSVG ||
    self.type == ZZFileBrowerFileTypeBMP ||
    self.type == ZZFileBrowerFileTypeTIF;
}

- (NSURL *)url {
    if (_path) {
        return [NSURL fileURLWithPath:_path isDirectory:self.isDir];
    }
    return nil;
}

- (NSString *)imageName {
    return ZZImageNameWithType(_type);
}

- (NSString *)sizeString {
    return [ZZFileBrowerManager sizeStringFromSize:_attributes.fileSize];
}

- (NSString *)createDateString {
    return [ZZFileBrowerManager stringFromDateByDateAndTime:_attributes.fileCreationDate];
}

- (NSString *)modifyDateString {
    return [ZZFileBrowerManager stringFromDateByDateAndTime:_attributes.fileModificationDate];
}

- (NSString *)lastOpenDateString {
    return [ZZFileBrowerManager stringFromDateByDateAndTime:_attributes.fileModificationDate];
}

/// MARK: - sort

- (void)sortChildrenWithType:(ZZFileBrowerItemSortType)sortType {
    _sortType = sortType;
    switch (sortType) {
        case ZZFileBrowerItemSortByName: [self sortByName]; break;
        case ZZFileBrowerItemSortByDate: [self sortByDate]; break;
        case ZZFileBrowerItemSortBySize: [self sortBySize]; break;
        case ZZFileBrowerItemSortByType: [self sortByType]; break;
    }
}

- (void)sortByName {
    self.children = [self.children sortedArrayUsingComparator:^NSComparisonResult(ZZFileBrowerItem * _Nonnull obj1, ZZFileBrowerItem * _Nonnull obj2) {
        return [obj1.name compare:obj2.name];
    }].mutableCopy;
}

- (void)sortByDate {
    self.children = [self.children sortedArrayUsingComparator:^NSComparisonResult(ZZFileBrowerItem * _Nonnull obj1, ZZFileBrowerItem * _Nonnull obj2) {
        return [obj1.modifyDateString compare:obj2.modifyDateString];
    }].mutableCopy;
}

- (void)sortBySize {
    self.children = [self.children sortedArrayUsingComparator:^NSComparisonResult(ZZFileBrowerItem * _Nonnull obj1, ZZFileBrowerItem * _Nonnull obj2) {
        return [obj1.sizeString compare:obj2.sizeString];
    }].mutableCopy;
}

- (void)sortByType {
    self.children = [self.children sortedArrayUsingComparator:^NSComparisonResult(ZZFileBrowerItem * _Nonnull obj1, ZZFileBrowerItem * _Nonnull obj2) {
        return [obj1.extension compare:obj2.extension];
    }].mutableCopy;
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
