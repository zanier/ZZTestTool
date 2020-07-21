//
//  HsTestToolDefine.h
//  HsTestTool
//
//  Created by handsome on 2020/7/3.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#ifndef HsTestToolDefine_h
#define HsTestToolDefine_h

#import "NSBundle+HsTestTool.h"

/// <QuickLook> 框架支持
#define HSTESTTOOL_NEED_QUICKLOOK    1

/// MARK: - 屏幕高度、宽度
#ifndef kScreenWidth
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#endif

#ifndef kScreenHeight
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#endif

/// MARK: - 判断iphoneX、XS（1125 X 2436px）、iPhone XS Max（1242 x 2688px）、iPhone XR（828 X 1792px）
#ifndef HsFileBrower_iPhoneX
#define HsFileBrower_iPhoneX (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2688), [[UIScreen mainScreen] currentMode].size) : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828,1792), [[UIScreen mainScreen] currentMode].size) : NO))
#endif


#ifndef HsFileBrower_StatusBarHeight
#define HsFileBrower_StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#endif

#ifndef HsFileBrower_SafeStatusBarHeight
#define HsFileBrower_SafeStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 40 ? 20 : 0)
#endif

#ifndef HsFileBrower_NavBarBottom
#define HsFileBrower_NavBarBottom (HsFileBrower_iPhoneX ? 88.0f + HsFileBrower_SafeStatusBarHeight : 64.0f + HsFileBrower_SafeStatusBarHeight)
#endif

#ifndef HsFileBrower_NavBarHeight
#define HsFileBrower_NavBarHeight 44.0f
#endif

#ifndef HsFileBrower_SearchBarHeight
#define HsFileBrower_SearchBarHeight 52.0f
#endif

#endif /* HsTestToolDefine_h */
