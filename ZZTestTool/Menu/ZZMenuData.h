//
//  ZZMenuData.h
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/13.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage, UIAction, ZZAction, UIContextMenuInteraction;

NS_ASSUME_NONNULL_BEGIN

@interface ZZMenuData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSArray<ZZAction *> *children;
@property (nonatomic, copy) NSArray<UIAction *> *uiActions API_AVAILABLE(ios(13.0));
@property (nonatomic, strong) UIContextMenuInteraction *interaction API_AVAILABLE(ios(13.0));;

+ (instancetype)menuDataWithTitle:(NSString *)title
                            image:(nullable UIImage *)image
                         children:(NSArray<ZZAction *> *)children;

@end

NS_ASSUME_NONNULL_END
