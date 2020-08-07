//
//  ZZMenuController.m
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/5.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "ZZMenuController.h"
#import "ZZActionViewController.h"

@interface ZZMenuController () <UIContextMenuInteractionDelegate, UIPopoverPresentationControllerDelegate> {
    NSString *_title;
    UIImage *_image;
}

@property (nonatomic, copy) NSArray<ZZAction *> *children;
@property (nonatomic, copy) NSArray<UIAction *> *uiActions API_AVAILABLE(ios(13.0));
@property (nonatomic, strong) UIContextMenuInteraction *interaction API_AVAILABLE(ios(13.0));;

@end

@implementation ZZMenuController

/// MARK: - life cycle

+ (instancetype)menuWithTitle:(NSString *)title
                        image:(nullable UIImage *)image
                     children:(NSArray<ZZAction *> *)children {
    ZZMenuController *menuController = [[ZZMenuController alloc] init];
    menuController->_title = title.copy;
    menuController->_image = image;
    menuController.children = children.copy;
    return menuController;;
}

- (void)addInteractionOnView:(UIView *)view interaction:(BOOL)ttt {
    _interactionView = view;
    if (!ttt) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [view addGestureRecognizer:longPress];
    } else if (@available(iOS 13.0, *)) {
        _interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
        [view addInteraction:_interaction];
    }
}

- (void)addInteractionOnView:(UIView *)view {
    _interactionView = view;
    if (@available(iOS 13.0, *)) {
        _interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
        [view addInteraction:_interaction];
    } else {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [view addGestureRecognizer:longPress];
    }
}

/// 长按
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //CGPoint location = [longPress locationInView:_interactionView];
        [self presentActionViewControllerFromView:_interactionView];
    }
}

- (void)presentActionViewControllerFromView:(UIView *)view {
    NSMutableArray<NSArray<ZZAction *> *> *children = [NSMutableArray array];
    NSMutableArray<ZZAction *> *currentSection = [NSMutableArray array];
    for (ZZAction *child in _children) {
        if (child.children && child.children) {
            if (currentSection.count) {
                [children addObject:currentSection.copy];
                [currentSection removeAllObjects];
            }
            [children addObject:child.children];
        } else {
            [currentSection addObject:child];
        }

    }
    if (currentSection.count) {
        [children addObject:currentSection.copy];
    }
    ZZActionViewController *actionViewController = [ZZActionViewController actionViewControllerWithTitle:_title image:_image children:children];
    
//    actionViewController.delegate = self;
    actionViewController.modalPresentationStyle = UIModalPresentationPopover;
    actionViewController.popoverPresentationController.delegate = self;
    actionViewController.popoverPresentationController.sourceView = _interactionView;
    actionViewController.popoverPresentationController.sourceRect = _interactionView.bounds;
    actionViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    if (@available(iOS 9.0, *)) {
        actionViewController.popoverPresentationController.canOverlapSourceViewRect = NO;
    } else {
        // Fallback on earlier versions
    }
    UIViewController *viewController;
    if (@available(iOS 13.0, *)) {
        viewController = UIApplication.sharedApplication.windows.firstObject.rootViewController;
    } else {
        viewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    }
    [viewController presentViewController:actionViewController animated:YES completion:nil];
}

/// MARK: - <UIPopoverPresentationControllerDelegate>
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (UIContextMenuInteraction *)contextMenuInteraction  API_AVAILABLE(ios(13.0)) {
    UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    return interaction;
}

/// 组织 Menu 菜单
- (UIMenu *)buildMenu API_AVAILABLE(ios(13.0)) {
    NSMutableArray<UIMenuElement *> *elements = [NSMutableArray arrayWithCapacity:_children.count];
    for (ZZAction *child in _children) {
        UIMenuElement *element = [child toUIMenuElement];
        [elements addObject:element];
    }
    UIMenu *menu = [UIMenu menuWithTitle:_title image:_image identifier:nil options:UIMenuOptionsDisplayInline children:elements];
    return menu;
}

/// MARK: - <UIContextMenuInteractionDelegate>

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location  API_AVAILABLE(ios(13.0)) {
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:@"qwe" previewProvider:^UIViewController * _Nullable{
        
        return nil;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        return [self buildMenu];
    }];
    return configuration;
}

@end
