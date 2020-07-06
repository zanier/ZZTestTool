//
//  NSBundle+HsTestTool.m
//  HsTestTool
//
//  Created by handsome on 2020/7/1.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "NSBundle+HsTestTool.h"
#import "HsTestBaseViewController.h"

@implementation NSBundle (HsTestTool)

+ (instancetype)hs_testToolBundle {
    static NSBundle *testToolBundle = nil;
    if (testToolBundle == nil) {
        testToolBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[HsTestBaseViewController class]] pathForResource:@"HsTestTool" ofType:@"bundle"]];
    }
    return testToolBundle;
}

+ (UIImage *)hs_imageNamed:(NSString *)imageName type:(NSString *)type {
    return [[UIImage imageWithContentsOfFile:[[self hs_testToolBundle] pathForResource:imageName ofType:type]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)hs_imageNamed:(NSString *)imageName {
    return [[UIImage imageWithContentsOfFile:[[self hs_testToolBundle] pathForResource:imageName ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
