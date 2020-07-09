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

@interface HsFileBrowerItem : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, copy, readonly) NSString *extension;
@property (nonatomic, assign, readonly) HsFileBrowerFileType type;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, assign, readonly) BOOL isDir;

@property (nullable, readonly) NSURL *url;
@property (nullable, readonly) NSString *imageName;
//@property (nullable, readonly) NSString *typeString;
@property (nullable, readonly) NSString *sizeString;
@property (nullable, readonly) NSString *createDateString;
@property (nullable, readonly) NSString *modifyDateString;
@property (nullable, readonly) NSString *lastOpenDateString;

@property (nonatomic, nullable, weak) HsFileBrowerItem *parent;
@property (nonatomic, nullable, copy) NSArray<HsFileBrowerItem *> *children;

@property (readonly) NSString *accessoryType;
@property (readonly) NSString *modificationDate;

- (instancetype)initWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
