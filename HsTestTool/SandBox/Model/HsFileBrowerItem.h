//
//  HsFileBrowerItem.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/28.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsFileBrowerHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HsFileBrowerItemSortType) {
    HsFileBrowerItemSortByName = 0,
    HsFileBrowerItemSortByDate,
    HsFileBrowerItemSortBySize,
    HsFileBrowerItemSortByType,
};

@interface HsFileBrowerItem : NSObject

- (instancetype)initWithPath:(NSString *)path;

/// readonly
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, assign, readonly) HsFileBrowerFileType type;
@property (nonatomic, copy, readonly) NSString *extension;
/// readonly getter
@property (readonly) BOOL isDir;
@property (readonly) BOOL isImage;
@property (nullable, readonly) NSURL *url;
@property (nullable, readonly) NSString *sizeString;
@property (nullable, readonly) NSString *createDateString;
@property (nullable, readonly) NSString *modifyDateString;
@property (nullable, readonly) NSString *lastOpenDateString;
@property (nullable, readonly) NSString *accessoryType;
//@property (nullable, readonly) NSString *modificationDate;
/// readwrite
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, nullable, weak) HsFileBrowerItem *parent;
@property (nonatomic, nullable, copy) NSMutableArray<HsFileBrowerItem *> *children;
@property (nonatomic, assign) NSUInteger childrenCount;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/// MARK: - sort

@property (readonly) HsFileBrowerItemSortType sortType;

- (void)sortChildrenWithType:(HsFileBrowerItemSortType)sortType;

@end

NS_ASSUME_NONNULL_END
