//
//  ZZActionViewController.h
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/6.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZActionViewController : UIViewController

+ (instancetype)actionViewControllerWithTitle:(NSString *)title image:(nullable UIImage *)image children:(NSArray<NSArray<ZZAction *> *> *)children;

@end

NS_ASSUME_NONNULL_END
