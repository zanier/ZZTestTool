//
//  AppDelegate.m
//  HsTestTool
//
//  Created by zanier on 2020/7/1.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyWindow];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    return YES;
}

- (void)donotuse {
//    UIToolbar *toolBar;
    
}

@end
