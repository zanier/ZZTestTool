//
//  ZZMenuData.m
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/13.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "ZZMenuData.h"
#import "ZZAction.h"

@interface ZZMenuData ()

@end

@implementation ZZMenuData

/// MARK: - init

+ (instancetype)menuDataWithTitle:(NSString *)title
                            image:(nullable UIImage *)image
                         children:(NSArray<ZZAction *> *)children {
    ZZMenuData *menuData = [[ZZMenuData alloc] init];
    menuData.title = title.copy;
    menuData.image = image;
    menuData.children = children.copy;
    return menuData;;
}

@end
