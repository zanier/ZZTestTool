//
//  ZZMenuController.m
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/5.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "ZZMenuController.h"

@interface ZZMenuController () <UIContextMenuInteractionDelegate> {
    NSString *_title;
    UIImage *_image;
}

@property (nonatomic, copy) NSArray<ZZAction *> *children;
@property (nonatomic, copy) NSArray<UIAction *> *uiActions API_AVAILABLE(ios(13.0));

@end

@implementation ZZMenuController

+ (instancetype)menuWithTitle:(NSString *)title
                        image:(nullable UIImage *)image
                   identifier:(nullable NSString *)identifier
                     children:(NSArray<ZZAction *> *)children {
    ZZMenuController *menuController = [[ZZMenuController alloc] init];
    menuController->_title = title.copy;
    menuController->_image = image;
    menuController.children = children.copy;
    return menuController;;
}

- (UIContextMenuInteraction *)contextMenuInteraction  API_AVAILABLE(ios(13.0)) {
    UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    return interaction;
}

- (UIMenu *)menu API_AVAILABLE(ios(13.0)) {
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:_children.count];
    for (ZZAction *child in _children) {
        UIAction *action = child.toUIAction;
        [actions addObject:action];
    }
    UIMenu *menu = [UIMenu menuWithTitle:_title image:_image identifier:UIMenuApplication options:UIMenuOptionsDisplayInline children:actions];
    return menu;
}

/// MARK: - <UIContextMenuInteractionDelegate>

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location  API_AVAILABLE(ios(13.0)) {
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:@"qwe" previewProvider:^UIViewController * _Nullable{
        
        return nil;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        return [self menu];
    }];
    return configuration;
}

@end
