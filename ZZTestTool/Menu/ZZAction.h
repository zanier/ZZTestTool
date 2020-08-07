//
//  ZZAction.h
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/6.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZAction;

typedef void (^ZZActionHandler)(__kindof ZZAction *action);

@interface ZZAction : NSObject <NSCopying>

/// Short display title.
@property (nonatomic, copy) NSString *title;

/// Image that can appear next to this action.
@property (nonatomic, nullable, copy) UIImage *image;

/// Elaborated title, if any.
@property (nonatomic, nullable, copy) NSString *discoverabilityTitle;

/// This action's identifier.
@property (nonatomic, readonly) NSString *identifier;

/// .
@property (nonatomic, nullable, copy) NSArray<ZZAction *> *children;

/// This action's style.
//@property (nonatomic) UIMenuElementAttributes attributes;

/// State that can appear next to this action.
//@property (nonatomic) UIMenuElementState state;

/*!
 * @abstract Creates a UIAction with the given arguments.
 *
 * @param title    The action's title.
 * @param image    Image that can appear next to this action, if needed.
 * @param identifier  The action's identifier. Pass nil to use an auto-generated identifier.
 * @param handler  Handler block. Called when the user selects the action.
 *
 * @return A new UIAction.
 */
+ (instancetype)actionWithTitle:(NSString *)title
                          image:(nullable UIImage *)image
                     identifier:(nullable NSString *)identifier
                        handler:(ZZActionHandler)handler;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (UIMenuElement *)toUIMenuElement API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
