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
#import "HsFileBrowerDefine.h"
#import "HsFileBrowerItem.h"
#import "HsFileBrowerPage.h"

@interface HsFileBrowerController () <HsFileBrowerScrollHeaderDelegate, HsFileBrowerPageDelegate>

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
    
//    _rootPage = [[HsFileBrowerPage alloc] init];
//    _rootPage.delegate = self;
    //    _rootPage.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pop)];
    //    self.navigation = [[UINavigationController alloc] initWithRootViewController:_rootPage];
    self.navigation = [[UINavigationController alloc] init];

    
    [self addChildViewController:_navigation];
    [self.view addSubview:_navigation.view];
//    [self.navigation.navigationBar addSubview:self.headerToolBar];
    [self.view addSubview:self.headerToolBar];
    [self.headerToolBar addSubview:self.scrollHeader];

    self.navigationController.navigationBar.hidden = YES;
    [self.navigation.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigation.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
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
//    frame.origin.y = CGRectGetHeight(self.navigation.navigationBar.bounds) - topPoint.y;
    frame.origin.y = HsFileBrower_NavBarHeight - topPoint.y;
    self.headerToolBar.frame = frame;
    self.scrollHeader.frame = self.headerToolBar.bounds;
//    CGFloat scrollBottom = CGRectGetMaxY(_headerToolBar.frame);
//    _collectionView.frame = CGRectMake(0, scrollBottom, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - scrollBottom);
}


- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enterSandBox {
    //NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"HsFileBrower" ofType:@"bundle"];
    //NSBundle *idBundle = [NSBundle bundleWithIdentifier:@"com.hundsun.HsBusinessEngine"];
    //NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"HsFileBrower" withExtension:@"bundle"];
    //NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
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
    [self enterDirectoryWithItem:_currentItem];
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
        HsFileBrowerPage *page = _navigation.viewControllers[idx];
        [_navigation popToViewController:page animated:YES];
        // 返回到上级的目录
        if (idx >= self.pathNavigation.count - 1) {
            return NO;
        }
        // 移除目录后面的路径
        [self.pathNavigation removeObjectsInRange:NSMakeRange(idx + 1, self.pathNavigation.count - idx - 1)];
        // 头部移动到当前目录，
        [self.scrollHeader popToIndex:idx];
    } else {
        HsFileBrowerPage *filePage = [[HsFileBrowerPage alloc] init];
        filePage.delegate = self;
        [filePage reloadAtDirectoryWithItem:item];
        if (_navigation.viewControllers.count == 0) {
            [_navigation pushViewController:filePage animated:NO];
        } else {
            [_navigation pushViewController:filePage animated:YES];
        }
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
//    HsFileBrowerPage *filePage = [[HsFileBrowerPage alloc] init];
//    filePage.delegate = self;
//    [filePage reloadAtDirectoryWithItem:item];
    [self enterDirectoryWithItem:item];
//    [_navigation pushViewController:filePage animated:YES];
}

@end
