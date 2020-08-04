//
//  ZZTestToolDefine.h
//  ZZTestTool
//
//  Created by zanier on 2020/7/3.
//  Copyright © 2020 zanier. All rights reserved.
//

#ifndef ZZTestToolDefine_h
#define ZZTestToolDefine_h

#import "NSBundle+ZZTestTool.h"
#import "ZZTestToolConfig.h"

/// MARK: - 屏幕高度、宽度
#ifndef kScreenWidth
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#endif

#ifndef kScreenHeight
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#endif

/// MARK: - 判断iphoneX、XS（1125 X 2436px）、iPhone XS Max（1242 x 2688px）、iPhone XR（828 X 1792px）
#ifndef ZZFileBrower_iPhoneX
#define ZZFileBrower_iPhoneX (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2688), [[UIScreen mainScreen] currentMode].size) : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828,1792), [[UIScreen mainScreen] currentMode].size) : NO))
#endif


#ifndef ZZFileBrower_StatusBarHeight
#define ZZFileBrower_StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#endif

#ifndef ZZFileBrower_SafeStatusBarHeight
#define ZZFileBrower_SafeStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 40 ? 20 : 0)
#endif

#ifndef ZZFileBrower_NavBarBottom
#define ZZFileBrower_NavBarBottom (ZZFileBrower_iPhoneX ? 88.0f + ZZFileBrower_SafeStatusBarHeight : 64.0f + ZZFileBrower_SafeStatusBarHeight)
#endif

#ifndef ZZFileBrower_NavBarHeight
#define ZZFileBrower_NavBarHeight 44.0f
#endif

#ifndef ZZFileBrower_SearchBarHeight
#define ZZFileBrower_SearchBarHeight 52.0f
#endif

#endif /* ZZTestToolDefine_h */
