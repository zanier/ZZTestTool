//
//  ZZTestToolBaseViewController.h
//  ZZTestTool
//
//  Created by zanier on 2020/7/1.
//  Copyright © 2020 zanier. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef HsGlobalDefine_h
#import <HsBusinessEngine/HsBaseViewController.h>
@interface ZZTestBaseViewController : HsBaseViewController
#else
@interface ZZTestBaseViewController : UIViewController
#endif

/// MARK: - alert

- (void)alertWithTitle:(NSString *)title
               message:(NSString *)massage;

- (void)alertWithTitle:(NSString *)title
               message:(NSString *)massage
         confirmAction:(void(^)(void))confirmAction;

@end

NS_ASSUME_NONNULL_END
