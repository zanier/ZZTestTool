//
//  ZZPlistBrowerNode.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/8.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HsPlistNodeType) {
    HsPlistNodeTypeUnknown = 0,
    HsPlistNodeTypeArray,
    HsPlistNodeTypeDictionary,
    HsPlistNodeTypeString,
    HsPlistNodeTypeNumber,
    HsPlistNodeTypeBinary,
};

@interface ZZPlistBrowerNode : NSObject <NSCopying>

/// 初始化方法
/// @param key 结点的 key 值，可为空
/// @param value 结点的值，不为空
- (instancetype)initWithKey:(nullable NSString *)key value:(nullable id)value;

/// 结点类型
@property (readonly) HsPlistNodeType type;
@property (readonly) NSString *typeString;

/// 结点在树中的深度。根深度为 1。
@property (readonly) NSInteger depth;
@property (nonatomic, nullable, weak, readonly) ZZPlistBrowerNode *parent;

/// 结点的展开状态
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;
@property (nonatomic, assign, getter=isVisiable) BOOL visiable;

/// 字典字段的 key 值，数组的元素 key 为 nil。
@property (nonatomic, nullable, copy) NSString *key;

/// 字段的值，仅支持基本数据类型
@property (nonatomic, strong) id value;

/// 字典或数组的元素数组
@property (nonatomic, strong) NSMutableArray<ZZPlistBrowerNode *> *children;

- (NSMutableArray<ZZPlistBrowerNode *> *)visiableChildren;

/// 在 systemFontOfSize：17 字体下字符串 key 的宽度，不超过500。
@property (readonly) CGFloat widthThatFit;

@end

UIKIT_EXTERN HsPlistNodeType hsHsPlistNodeTypeWithObject(id object);
UIKIT_EXTERN NSString *hsHsPlistNodeTypeStringWithType(HsPlistNodeType type);

NS_ASSUME_NONNULL_END
