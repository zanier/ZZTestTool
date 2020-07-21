//
//  HsPlistBrowerNode.m
//  HsBusinessEngine
//
//  Created by ZZ on 2020/6/8.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsPlistBrowerNode.h"

@interface HsPlistBrowerNode ()

@property (nonatomic, assign) HsPlistNodeType type;
@property (nonatomic, assign) NSInteger depth;
@property (nonatomic, assign) CGFloat widthThatFit;

@end

@implementation HsPlistBrowerNode

- (instancetype)initWithKey:(NSString *)key value:(id)value {
    if (self = [super init]) {
        _depth = 1;
        _visiable = YES;
        self.key = key;
        self.value = value;
    }
    return self;
}

- (instancetype)initWithKey:(NSString *)key value:(id)value depth:(NSInteger)depth {
    if (self = [super init]) {
        _depth = depth;
        _visiable = YES;
        self.key = [key copy];
        self.value = value;
    }
    return self;
}

- (void)setKey:(NSString *)key {
    _key = [key copy];
    CGSize size = [_key sizeWithAttributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
    }];
    _widthThatFit = size.width > 500 ? 500: size.width;
}

/// 设置数据
/// @param value 基本类型数据
- (void)setValue:(id)value {
    if (_value == value) {
        return;
    }
    _value = value;
    // 获取类型
    _type = hsHsPlistNodeTypeWithObject(value);
    [self.children removeAllObjects];
    if ([value isKindOfClass:[NSArray class]]) {
        // 数组
        NSArray *array = (NSArray *)value;
        // 递归设置子结点
        for (id child in array) {
            HsPlistBrowerNode *node = [[HsPlistBrowerNode alloc] initWithKey:nil value:child depth:self.depth + 1];
            [self.children addObject:node];
        }
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        // 字典
        NSDictionary *dictionary = (NSDictionary *)value;
        // 递归设置子结点
        for (id key in dictionary.allKeys) {
            id value = [dictionary objectForKey:key];
            HsPlistBrowerNode *node = [[HsPlistBrowerNode alloc] initWithKey:key value:value depth:self.depth + 1];
            [self.children addObject:node];
        }
    }
}

- (void)setDepth:(NSInteger)depth {
    if (_depth == depth) {
        return;
    }
    _depth = depth;
    for (HsPlistBrowerNode *node in self.children) {
        [node setDepth:depth + 1];
    }
}

- (NSString *)typeString {
    return hsHsPlistNodeTypeStringWithType(self.type);
}

- (NSMutableArray<HsPlistBrowerNode *> *)visiableChildren {
    NSMutableArray *visiableChildren = [NSMutableArray arrayWithCapacity:self.children.count * 2];
    for (HsPlistBrowerNode *child in self.children) {
        if (child.isVisiable) {
            [visiableChildren addObject:child];
            if (child.expanded) {
                [visiableChildren addObjectsFromArray:[child visiableChildren]];
            }
        }
    }
    return visiableChildren;
}

- (NSMutableArray<HsPlistBrowerNode *> *)children {
    if (!_children) {
        _children = [[NSMutableArray alloc] init];
    }
    return _children;
}

/// MARK: - <NSCopying>

- (id)copyWithZone:(NSZone *)zone {
    HsPlistBrowerNode *copyItem = [[HsPlistBrowerNode allocWithZone:zone] init];
    if (copyItem) {
        copyItem.type = self.type;
        copyItem.key = self.key;
        copyItem.value = self.value;
        copyItem.depth = self.depth;
        copyItem.expanded = self.expanded;
        copyItem.visiable = self.visiable;
        copyItem.children = self.children.mutableCopy;
        copyItem.widthThatFit = self.widthThatFit;
    }
    return copyItem;
}

- (NSString *)description {
    NSString *superDescription = [super description];
    return [NSString stringWithFormat:@"%@\ntype\t= %@ \nkey\t= %@ \nvalue\t= %@", superDescription, self.typeString, self.key, self.value];
}

@end

/// 获取结点数据类型
/// @param object 结点数据
HsPlistNodeType hsHsPlistNodeTypeWithObject(id object) {
    if (!object) {
        return HsPlistNodeTypeUnknown;
    }
    if ([object isKindOfClass:[NSString class]]) {
        return HsPlistNodeTypeString;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return HsPlistNodeTypeNumber;
    } else if ([object isKindOfClass:[NSData class]]) {
        return HsPlistNodeTypeBinary;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        return HsPlistNodeTypeDictionary;
    } else if ([object isKindOfClass:[NSArray class]]) {
        return HsPlistNodeTypeArray;
    }
    return HsPlistNodeTypeUnknown;
}

/// 结点类型转字符串
/// @param type 结点类型
NSString *hsHsPlistNodeTypeStringWithType(HsPlistNodeType type) {
    switch (type) {
        case HsPlistNodeTypeArray: return @"NSArray";
        case HsPlistNodeTypeString: return @"NSString";
        case HsPlistNodeTypeBinary: return @"NSData";
        case HsPlistNodeTypeNumber: return @"NSNumber";
        case HsPlistNodeTypeDictionary: return @"NSDictionary";
        default: return @"unknown";
    }
}
