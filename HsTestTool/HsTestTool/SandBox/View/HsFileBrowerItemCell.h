//
//  HsFileBrowerItemCell.h
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/28.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HsFileBrowerItem.h"

NS_ASSUME_NONNULL_BEGIN

@class HsFileBrowerItemCell;

@protocol HsFileBrowerItemCellDelegate <NSObject>

@optional

- (void)cellDidLongPressed:(HsFileBrowerItemCell *)cell;

- (BOOL)cell:(HsFileBrowerItemCell *)cell shouldEndRenamingWithName:(NSString *)name;

@end

@interface HsFileBrowerItemCell : UICollectionViewCell

@property (nonatomic, strong) HsFileBrowerItem *item;

@property (nonatomic, nullable, weak) id<HsFileBrowerItemCellDelegate> delegate;

@property (readonly) UIImageView *imageView;

- (void)beginRenamingItem;
- (void)endRenamingItem;

@end

NS_ASSUME_NONNULL_END
