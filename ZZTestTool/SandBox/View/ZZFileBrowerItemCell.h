//
//  ZZFileBrowerItemCell.h
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/28.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFileBrowerItem.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZFileBrowerItemCell;

@protocol ZZFileBrowerItemCellDelegate <NSObject>

@optional

- (void)cellDidLongPressed:(ZZFileBrowerItemCell *)cell;

- (BOOL)cell:(ZZFileBrowerItemCell *)cell shouldEndRenamingWithName:(NSString *)name;

@end

@interface ZZFileBrowerItemCell : UICollectionViewCell

@property (nonatomic, strong) ZZFileBrowerItem *item;

@property (nonatomic, nullable, weak) id<ZZFileBrowerItemCellDelegate> delegate;

/// 是否是选择模式
@property (nonatomic, assign, getter=isSelecting) BOOL selecting;
///// 是否已选中
//@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (readonly) UIImageView *imageView;

/// 进入、退出重命名编辑名称模式，通过代理回调结果
- (void)beginRenamingItem;
- (void)endRenamingItem;

@end

NS_ASSUME_NONNULL_END
