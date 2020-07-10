//
//  NSBundle+HsTestTool.h
//  HsTestTool
//
//  Created by handsome on 2020/7/1.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (HsTestTool)

+ (instancetype)hs_testToolBundle;

+ (nullable UIImage *)hs_imageNamed:(nullable NSString *)imageName
                               type:(nullable NSString *)type
                        inDirectory:(nullable NSString *)directory;

@end

NS_ASSUME_NONNULL_END
