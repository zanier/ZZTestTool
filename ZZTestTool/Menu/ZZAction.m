//
//  ZZAction.m
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/6.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "ZZAction.h"

@interface ZZAction () {
    NSString *_identifier;
}

@property (nonatomic, copy) ZZActionHandler handler;

@end

@implementation ZZAction

+ (instancetype)actionWithTitle:(NSString *)title
                          image:(nullable UIImage *)image
                     identifier:(nullable NSString *)identifier
                        handler:(ZZActionHandler)handler {
    ZZAction *action = [[ZZAction alloc] init];
    action.title = title;
    action.image = image;
    action->_identifier = identifier;
    action.handler = handler;
    return action;
}

- (id)copyWithZone:(NSZone *)zone {
    ZZAction *action = [[ZZAction alloc] init];
    action.title = self.title;
    action.image = self.image;
    action.discoverabilityTitle = self.discoverabilityTitle;
    action->_identifier = _identifier;
    action.handler = self.handler;
    return action;
}

- (UIAction *)toUIAction API_AVAILABLE(ios(13.0)) {
    UIAction *action = [UIAction actionWithTitle:_title image:_image identifier:_identifier handler:^(__kindof UIAction * _Nonnull action) {
        self.handler(self);
    }];
    return action;
}

@end
