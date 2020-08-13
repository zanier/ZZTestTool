//
//  ZZMenuController.h
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/5.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZAction.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZZMenuStyle) {
    ZZMenuStylePlain,
    ZZMenuStyleGroup,
};

@interface ZZMenuController : NSObject

//+ (instancetype)menuWithTitle:(NSString *)title
//                        image:(nullable UIImage *)image
//                     children:(NSArray<ZZAction *> *)children;

//@property (nonatomic, weak) __kindof UIView *interactionView;

- (void)addInteractionOnView:(UIView *)view;
- (void)addInteractionOnView:(UIView *)view interaction:(BOOL)ttt;

//- (UIContextMenuInteraction *)contextMenuInteraction  API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
