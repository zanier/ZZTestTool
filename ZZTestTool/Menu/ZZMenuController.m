//
//  ZZMenuController.m
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/5.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "ZZMenuController.h"
#import "ZZActionViewController.h"
#import <AudioToolBox/AudioServices.h>
#import "ZZMenuData.h"

@interface ZZMenuController () <UIContextMenuInteractionDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, copy) NSMapTable<__kindof UIView *, ZZMenuData *> *mapTable;
@property (nonatomic, copy) NSMapTable<UIContextMenuInteraction *, __kindof UIView *> *mapTable2 API_AVAILABLE(ios(13.0));

@end

@implementation ZZMenuController

/// MARK: - life cycle

//+ (instancetype)menuWithTitle:(NSString *)title
//                        image:(nullable UIImage *)image
//                     children:(NSArray<ZZAction *> *)children {
//    ZZMenuController *menuController = [[ZZMenuController alloc] init];
//    menuController->_title = title.copy;
//    menuController->_image = image;
//    menuController.children = children.copy;
//    return menuController;;
//}

//- (void)addInteractionOnView:(UIView *)view interaction:(BOOL)ttt {
//    _interactionView = view;
//    if (!ttt) {
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//        [view addGestureRecognizer:longPress];
//    } else if (@available(iOS 13.0, *)) {
//        _interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
//        [view addInteraction:_interaction];
//    }
//}

- (void)addInteractionOnView:(UIView *)view
                       title:(NSString *)title
                       image:(nullable UIImage *)image
                    children:(NSArray<ZZAction *> *)children {
    ZZMenuData *menuData = [ZZMenuData menuDataWithTitle:title image:image children:children];
    if (@available(iOS 13.0, *)) {
        UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
        [view addInteraction:interaction];
        menuData.interaction = interaction;
        [self.mapTable setObject:menuData forKey:view];
        [self.mapTable2 setObject:view forKey:interaction];
    } else {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [view addGestureRecognizer:longPress];
        [self.mapTable setObject:menuData forKey:view];
    }
}

/// 长按
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        // 触感反馈
        if (@available(iOS 10.0, *)) {
            UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
            [generator prepare];
            [generator impactOccurred];
        } else {
            // Fallback on earlier versions
        }
        //CGPoint location = [longPress locationInView:_interactionView];
        [self presentActionViewControllerFromView:longPress.view];
    }
}

- (void)presentActionViewControllerFromView:(UIView *)view {
    NSMutableArray<NSArray<ZZAction *> *> *children = [NSMutableArray array];
    NSMutableArray<ZZAction *> *currentSection = [NSMutableArray array];
    ZZMenuData *menuData = [self.mapTable objectForKey:view];
    if (!menuData) return;
    for (ZZAction *child in menuData.children) {
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
    ZZActionViewController *actionViewController = [ZZActionViewController actionViewControllerWithTitle:menuData.title image:menuData.image children:children];
    
//    actionViewController.delegate = self;
    actionViewController.modalPresentationStyle = UIModalPresentationPopover;
    actionViewController.popoverPresentationController.delegate = self;
    actionViewController.popoverPresentationController.sourceView = view;
    actionViewController.popoverPresentationController.sourceRect = view.bounds;
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
- (UIMenu *)buildMenuWithInterAction:(UIContextMenuInteraction *)interaction API_AVAILABLE(ios(13.0)) {
    UIView *view = [self.mapTable2 objectForKey:interaction];
    if (!view) return nil;
    ZZMenuData *menuData = [self.mapTable objectForKey:view];
    if (!menuData) return nil;
    NSMutableArray<UIMenuElement *> *elements = [NSMutableArray arrayWithCapacity:menuData.children.count];
    for (ZZAction *child in menuData.children) {
        UIMenuElement *element = [child toUIMenuElement];
        [elements addObject:element];
    }
    UIMenu *menu = [UIMenu menuWithTitle:menuData.title image:menuData.image identifier:nil options:UIMenuOptionsDisplayInline children:elements];
    return menu;
}

/// MARK: - <UIContextMenuInteractionDelegate>

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location  API_AVAILABLE(ios(13.0)) {
    
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:@"qwe" previewProvider:^UIViewController * _Nullable{
        
        return nil;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        return [self buildMenuWithInterAction:interaction];
    }];
    return configuration;
}

/// MARK: - getter

- (NSMapTable<__kindof UIView *,ZZMenuData *> *)mapTable {
    if (!_mapTable) {
        _mapTable = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _mapTable;
}

- (NSMapTable<__kindof UIView *,ZZMenuData *> *)mapTable2 {
    if (!_mapTable2) {
        _mapTable2 = [NSMapTable weakToWeakObjectsMapTable];
    }
    return _mapTable2;
}

@end
