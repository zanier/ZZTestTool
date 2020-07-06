//
//  HsFileBrowerDefine.h
//  HsTestTool
//
//  Created by handsome on 2020/7/3.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#ifndef HsFileBrowerDefine_h
#define HsFileBrowerDefine_h

//MARK: - 屏幕高度、宽度
#ifndef kScreenWidth
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#endif

#ifndef kScreenHeight
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#endif

//MARK: - 判断iphoneX、XS（1125 X 2436px）、iPhone XS Max（1242 x 2688px）、iPhone XR（828 X 1792px）
#ifndef HsFileBrower_iPhoneX
#define HsFileBrower_iPhoneX (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2688), [[UIScreen mainScreen] currentMode].size) : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828,1792), [[UIScreen mainScreen] currentMode].size) : NO))
#endif

#ifndef HsFileBrower_SafeStatusBarHeight
#define HsFileBrower_SafeStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height == 40 ? 20 : 0)
#endif

#ifndef HsFileBrower_NavBarHeight
#define HsFileBrower_NavBarHeight (HsFileBrower_iPhoneX ? 88.0f + HsFileBrower_SafeStatusBarHeight : 64.0f + HsFileBrower_SafeStatusBarHeight)
#endif


#endif /* HsFileBrowerDefine_h */
