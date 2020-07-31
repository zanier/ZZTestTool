//
//  HsPlistBrowerController.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/7/13.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "HsPlistBrowerController.h"
#import "HsPlistBrowerPage.h"

@interface HsPlistBrowerController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) HsPlistBrowerPage *plistPage;

@end

@implementation HsPlistBrowerController

/// MARK: - init

/// 工程创建方法
+ (instancetype)createPage:(NSDictionary*)params {
    HsPlistBrowerController *page = [[HsPlistBrowerController alloc] init];
    if (params && params[HsPlistBrowerPageObjectCreateKey]) {
        id obj = params[HsPlistBrowerPageObjectCreateKey];
        page.object = obj;
    } else if (params && params[HsPlistBrowerPagePlsitFilePathCreateKey]) {
        NSString *plistFilePath = params[HsPlistBrowerPagePlsitFilePathCreateKey];
        page.path = plistFilePath;
    }
    return page;
}

/// 初始化方法
/// @param anObject 基本类型数据，如NSArray、NSDictionary、NSString、NSNumber、NSData等
- (instancetype)initWithObject:(id)anObject {
    if (self == [super init]) {
        _object = anObject;
    }
    return self;
}

/// 初始化方法
/// @param path 根结点文件（.plist）路径
- (instancetype)initWithPlistFilePath:(NSString *)path {
    if (self == [super init]) {
        _path = path.copy;
    }
    return self;
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
    if (!_plistPage) {
        if (_object) {
            _plistPage = [[HsPlistBrowerPage alloc] initWithObject:_object];
        } else if (_path) {
            _plistPage = [[HsPlistBrowerPage alloc] initWithPlistFilePath:_path];
        } else  {
            _plistPage = [[HsPlistBrowerPage alloc] init];
        }
    }
    /// done
    UIViewController *rootVC = _plistPage;
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
