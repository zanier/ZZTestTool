//
//  HsPlistBrowerController.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/7/13.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsPlistBrowerController.h"
#import "HsPlistBrowerPage.h"

@interface HsPlistBrowerController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) HsPlistBrowerPage *plistPage;

@end

@implementation HsPlistBrowerController

/// MARK: - init

+ (instancetype)createPage:(NSDictionary*)params {
    HsPlistBrowerController *page = [[HsPlistBrowerController alloc] init];
    if (params[HsPlistBrowerPageObjectCreateKey]) {
        id obj = params[HsPlistBrowerPageObjectCreateKey];
        page.plistPage = [[HsPlistBrowerPage alloc] initWithObject:obj];
    } else if (params[HsPlistBrowerPagePlsitFilePathCreateKey]) {
        NSString *plistFilePath = params[HsPlistBrowerPagePlsitFilePathCreateKey];
        page.plistPage = [[HsPlistBrowerPage alloc] initWithPlistFilePath:plistFilePath];
    } else {
        page.plistPage = [[HsPlistBrowerPage alloc] init];
    }
    return page;
}

/// MARK: - life cycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isBeingDismissed && !self.isBeingPresented) {
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)setupNavigation {
    /// done
    UIViewController *rootVC = self.plistPage;
    rootVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pop)];
    rootVC.navigationItem.leftBarButtonItem.tintColor = UIColor.systemBlueColor;
    /// navigation
    self.navigation = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.navigation.delegate = self;
    [self addChildViewController:_navigation];
    [self.navigation.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigation.navigationBar.tintColor = UIColor.systemBlueColor;
    self.navigation.navigationItem.titleView.backgroundColor = UIColor.darkTextColor;
    self.navigation.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.view addSubview:_navigation.view];
    [self.navigation.navigationBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName : UIColor.darkTextColor,
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
