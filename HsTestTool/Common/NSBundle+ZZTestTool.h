//
//  NSBundle+HsTestTool.h
//  HsTestTool
//
//  Created by zanier on 2020/7/1.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (ZZTestTool)

+ (instancetype)hs_testToolBundle;

+ (nullable UIImage *)hs_imageNamed:(nullable NSString *)imageName
                               type:(nullable NSString *)type
                        inDirectory:(nullable NSString *)directory;

@end

NS_ASSUME_NONNULL_END
