//
//  ZZFileBrowerItem.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/28.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZFileBrowerHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZZFileBrowerItemSortType) {
    ZZFileBrowerItemSortByName = 0,
    ZZFileBrowerItemSortByDate,
    ZZFileBrowerItemSortBySize,
    ZZFileBrowerItemSortByType,
};

@interface ZZFileBrowerItem : NSObject

- (instancetype)initWithPath:(NSString *)path;

/// readonly
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, assign, readonly) ZZFileBrowerFileType type;
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
@property (nonatomic, nullable, weak) ZZFileBrowerItem *parent;
@property (nonatomic, nullable, copy) NSMutableArray<ZZFileBrowerItem *> *children;
@property (nonatomic, assign) NSUInteger childrenCount;
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/// MARK: - sort

@property (readonly) ZZFileBrowerItemSortType sortType;

- (void)sortChildrenWithType:(ZZFileBrowerItemSortType)sortType;

@end

NS_ASSUME_NONNULL_END
