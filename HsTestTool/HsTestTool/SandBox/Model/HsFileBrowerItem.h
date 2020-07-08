//
//  HsFileBrowerItem.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/28.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HsFileBrowerItem : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSDictionary *attributes;
@property (nonatomic, assign, readonly) BOOL isDir;

@property (nonatomic, strong, readonly) NSString *typeString;
@property (nonatomic, strong, readonly) NSString *sizeString;
@property (nonatomic, strong, readonly) NSString *createDateString;
@property (nonatomic, strong, readonly) NSString *modifyDateString;
@property (nonatomic, strong, readonly) NSString *lastOpenDateString;

@property (nonatomic, nullable, weak) HsFileBrowerItem *parent;
@property (nonatomic, nullable, copy) NSArray<HsFileBrowerItem *> *children;

@property (readonly) NSString *accessoryType;
@property (readonly) NSString *detailText;
@property (readonly) NSString *modificationDate;

- (instancetype)initWithPath:(NSString *)path
                        name:(NSString *)name
                  attributes:(NSDictionary *)attributes
                      parent:(nullable HsFileBrowerItem *)parent;

@end

NS_ASSUME_NONNULL_END
