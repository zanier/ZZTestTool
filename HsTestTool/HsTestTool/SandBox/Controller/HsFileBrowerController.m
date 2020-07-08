//
//  HsFileBrowerController.m
//  HsTestTool
//
//  Created by handsome on 2020/7/5.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "HsFileBrowerController.h"
#import "HsFileBrowerScrollHeader.h"
#import "HsFileBrowerManager.h"
#import "HsTestToolDefine.h"
#import "HsFileBrowerItem.h"
#import "HsFileBrowerPage.h"

@interface HsFileBrowerController () <HsFileBrowerScrollHeaderDelegate, HsFileBrowerPageDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) HsFileBrowerPage *rootPage;

@property (nonatomic, strong) UIToolbar *headerToolBar;
@property (nonatomic, strong) HsFileBrowerScrollHeader *scrollHeader; // 顶部滑动式图

@property (nonatomic, strong) NSMutableArray<HsFileBrowerItem *> *pathNavigation;
@property (nonatomic, strong) HsFileBrowerItem *currentItem;

@end

@implementation HsFileBrowerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headerToolBar];
    [self.headerToolBar addSubview:self.scrollHeader];

    self.navigationController.navigationBar.hidden = YES;
    
    [self enterSandBox];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isBeingDismissed && !self.isBeingPresented) {
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGPoint topPoint = [self.view convertPoint:CGPointZero toView:[UIApplication sharedApplication].windows.firstObject];
    CGRect frame = self.scrollHeader.bounds;
    frame.origin.y = HsFileBrower_NavBarBottom - topPoint.y;
    self.headerToolBar.frame = frame;
    self.scrollHeader.frame = self.headerToolBar.bounds;
}


- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enterSandBox {
    NSString *homeDirectory = NSHomeDirectory();
    NSString *homeName = [homeDirectory lastPathComponent];
    NSLog(@"homeDirectory: \n%@", homeDirectory);
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:homeDirectory error:&error];
    if (error) {
        return;
    }
    _currentItem = [[HsFileBrowerItem alloc] initWithPath:homeDirectory name:homeName attributes:attributes parent:nil];
//    [_rootPage reloadAtDirectoryWithItem:_currentItem];
//    [self enterDirectoryWithItem:_currentItem];
    
    // root page
    _rootPage = [[HsFileBrowerPage alloc] init];
    _rootPage.delegate = self;
    [_rootPage reloadAtDirectoryWithItem:_currentItem];
    _rootPage.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pop)];
    // push
    self.navigation = [[UINavigationController alloc] initWithRootViewController:_rootPage];
    self.navigation.delegate = self;
    [self addChildViewController:_navigation];
    [self.navigation.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigation.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.view addSubview:_navigation.view];
    // 进入下级目录
    [self.pathNavigation addObject:_currentItem];
    // 移动到当前目录
    [self.scrollHeader push:_currentItem.name];
    [self.view bringSubviewToFront:self.headerToolBar];
}

/// 进入文件夹
/// 根据记录自动pop或push，在进入下级或返回上级都可以使用
/// @param item 文件夹数据
- (BOOL)enterDirectoryWithItem:(HsFileBrowerItem *)item {
    BOOL didReload = NO;
//    BOOL didReload = [self reloadAtDirectoryWithItem:item];
//    if (!didReload) {
//        // 路径不正确，不能刷新
//        return NO;
//    }
    _currentItem = item;
    if ([self.pathNavigation containsObject:item]) {
        NSInteger idx = [self.pathNavigation indexOfObject:item];
        // 返回到上级的目录
        if (idx >= self.pathNavigation.count - 1) {
            return NO;
        }
        // pop
        HsFileBrowerPage *page = _navigation.viewControllers[idx];
        [_navigation popToViewController:page animated:YES];
        // 移除目录后面的路径
        [self.pathNavigation removeObjectsInRange:NSMakeRange(idx + 1, self.pathNavigation.count - idx - 1)];
        // 头部移动到当前目录，
        [self.scrollHeader popToIndex:idx];
    } else {
        // push
        HsFileBrowerPage *filePage = [[HsFileBrowerPage alloc] init];
        filePage.delegate = self;
        [filePage reloadAtDirectoryWithItem:item];
        [_navigation pushViewController:filePage animated:YES];
        // 进入下级目录
        [self.pathNavigation addObject:item];
        // 移动到当前目录
        [self.scrollHeader push:item.name];
    }
    return didReload;
}

/// MARK: - getter

- (NSMutableArray<HsFileBrowerItem *> *)pathNavigation {
    if (!_pathNavigation) {
        _pathNavigation = [NSMutableArray array];
    }
    return _pathNavigation;
}

- (UIToolbar *)headerToolBar {
    if (_headerToolBar) {
        return _headerToolBar;
    }
    _headerToolBar = [[UIToolbar alloc] init];
    _headerToolBar.barStyle = self.navigationController.navigationBar.barStyle;
    _headerToolBar.tintColor = self.navigationController.navigationBar.tintColor;
    _headerToolBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    [_headerToolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny];
    return _headerToolBar;
}

- (HsFileBrowerScrollHeader *)scrollHeader {
    if (!_scrollHeader) {
        _scrollHeader = [HsFileBrowerScrollHeader viewWithextArray:nil];
        _scrollHeader.backgroundColor = [UIColor clearColor];
        _scrollHeader.delegate = self;
    }
    return _scrollHeader;
}

/// MARK: - <UINavigationControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSInteger idx = [self.navigation.viewControllers indexOfObject:viewController];
    if (idx == NSNotFound) {
        return;
    }
    // 移除目录后面的路径
    [self.pathNavigation removeObjectsInRange:NSMakeRange(idx + 1, self.pathNavigation.count - idx - 1)];
    // 头部移动到当前目录，
    [self.scrollHeader popToIndex:idx];
}

/// MARK: - <WBSelectionScrollHeaderDelegate>

/// 是否允许选择某一级，默认YES允许
/// @param scrollHeader 滑动选择视图
/// @param idx 选择级别索引
- (BOOL)scrollHeader:(HsFileBrowerScrollHeader *)scrollHeader shouldSelectAtIndex:(NSInteger)idx {
    return YES;
}

/// 选择了某一级
/// @param scrollHeader 滑动选择视图
/// @param idx 选择级别索引
- (void)scrollHeader:(HsFileBrowerScrollHeader *)scrollHeader didSelectAtIndex:(NSInteger)idx {
    /// 进入目标文件夹
    HsFileBrowerItem *item = self.pathNavigation[idx];
    [self enterDirectoryWithItem:item];
}

/// MARK: - <HsFileBrowerScrollHeaderDelegate>

- (void)filePage:(HsFileBrowerPage *)page didSlectItem:(HsFileBrowerItem *)item {
    if (item.isDir) {
        [self enterDirectoryWithItem:item];
//    } else if (item.typeString) {
        
    } else {
        Class plistBrowerPagCls = NSClassFromString(@"HsPlistBrowerPage");
        if (plistBrowerPagCls) {
            id plistBrowerPage = [plistBrowerPagCls alloc];
            SEL initSelector = NSSelectorFromString(@"initWithPlistFilePath:");
            if ([plistBrowerPage respondsToSelector:initSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [plistBrowerPage performSelector:initSelector withObject:item.path];
#pragma clang diagnostic pop
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:plistBrowerPage];
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
    }
}

@end
