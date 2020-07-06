//
//  HsTestToolBaseViewController.h
//  HsTestTool
//
//  Created by handsome on 2020/7/1.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef HsGlobalDefine_h
#import <HsBusinessEngine/HsBaseViewController.h>
@interface HsTestBaseViewController : HsBaseViewController
#else
@interface HsTestBaseViewController : UIViewController
#endif

@end

NS_ASSUME_NONNULL_END
