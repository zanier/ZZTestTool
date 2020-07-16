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

@interface HsFileBrowerController () <HsFileBrowerScrollHeaderDelegate, HsFileBrowerPageDelegate, UINavigationControllerDelegate, HsQLPreviewControllerDataSource> {
    HsFileBrowerItem *_currentItem;
}

@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) HsFileBrowerPage *rootPage;

@property (nonatomic, strong) UIToolbar *headerToolBar;
@property (nonatomic, strong) HsFileBrowerScrollHeader *scrollHeader; // 顶部滑动式图

@property (nonatomic, strong) NSMutableArray<HsFileBrowerItem *> *pathNavigation;

@end

@implementation HsFileBrowerController

/// MARK: - init

+ (instancetype)createPage:(NSDictionary *)params {
    NSString *rootPath = nil;
    if (params && params[HsFileBrowerControllerRootPathKey]) {
        rootPath = params[HsFileBrowerControllerRootPathKey];
    }
    HsFileBrowerController *page = [[HsFileBrowerController alloc] initWithRootPath:rootPath];
    return page;
}

/// 初始化方法
/// @param rootPath 根目录文件路径
- (instancetype)initWithRootPath:(NSString *)rootPath {
    if (self = [super init]) {
        _rootPath = [rootPath copy];
    }
    return self;
}

/// MARK: - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headerToolBar];
    [self.headerToolBar addSubview:self.scrollHeader];
    self.navigationController.navigationBar.hidden = YES;
    /// 进入根目录
    if (_rootPath) {
        [self loadRootPath:_rootPath];
    } else {
        [self enterSandBox];
        //[self enterMainBundle];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isBeingDismissed && !self.isBeingPresented) {
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

/// MARK: - root path

- (void)setRootPath:(NSString *)rootPath {
    if (![_rootPath isEqualToString:rootPath]) {
        _rootPath = [rootPath copy];
        [self loadRootPath:_rootPath];
    }
}

- (void)enterMainBundle {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    _rootPath = bundlePath;
    [self loadRootPath:bundlePath];
}

- (void)enterSandBox {
    NSString *homeDirectory = NSHomeDirectory();
    _rootPath = homeDirectory;
    [self loadRootPath:homeDirectory];
}

- (void)loadRootPath:(NSString *)rootPath {
    NSLog(@"Root Path: \n%@", rootPath);
    NSError *error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:rootPath error:&error];
    if (error) return;
    _currentItem = [[HsFileBrowerItem alloc] initWithPath:rootPath];
    _currentItem.attributes = attributes;
    // root page
    _rootPage = [[HsFileBrowerPage alloc] init];
    _rootPage.delegate = self;
    [_rootPage reloadAtDirectoryWithItem:_currentItem];
    _rootPage.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pop)];
    _rootPage.navigationItem.leftBarButtonItem.tintColor = UIColor.systemBlueColor;
    // push
    self.navigation = [[UINavigationController alloc] initWithRootViewController:_rootPage];
    self.navigation.delegate = self;
    [self addChildViewController:_navigation];
    [self.navigation.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigation.navigationBar.tintColor = UIColor.systemBlueColor;
    self.navigation.navigationItem.titleView.backgroundColor = UIColor.darkTextColor;
    self.navigation.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.view addSubview:self.navigation.view];
    [self.navigation.navigationBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName : UIColor.darkTextColor,
    }];
    // 进入下级目录
    [self.pathNavigation addObject:_currentItem];
    // 移动到当前目录
    UIImage *image = [HsFileBrowerManager imageWithFileType:_currentItem.type scale:1];
    [self.scrollHeader push:_currentItem.name image:image];
    [self.view bringSubviewToFront:self.headerToolBar];
}

/// 进入文件夹
/// 根据记录自动pop或push，在进入下级或返回上级都可以使用
/// @param item 文件夹数据
- (BOOL)enterDirectoryWithItem:(HsFileBrowerItem *)item {
    BOOL didReload = NO;
    _currentItem = item;
    if ([self.pathNavigation containsObject:item]) {
        NSInteger idx = [self.pathNavigation indexOfObject:item];
        // 返回到上级的目录
        if (idx >= self.pathNavigation.count - 1) {
            return NO;
        }
        // pop
        HsFileBrowerPage *page = _navigation.viewControllers[idx];
        [self.navigation popToViewController:page animated:YES];
        // 移除目录后面的路径
        [self.pathNavigation removeObjectsInRange:NSMakeRange(idx + 1, self.pathNavigation.count - idx - 1)];
        // 头部移动到当前目录，
        [self.scrollHeader popToIndex:idx];
    } else {
        // push
        UIViewController *nextPage = [self pageWithItem:item];
        if (nextPage) {
            nextPage.title = item.name;
            [self.navigation pushViewController:nextPage animated:YES];
            /// 进入下级目录
            [self.pathNavigation addObject:item];
            /// 移动到当前目录
            UIImage *image = [HsFileBrowerManager imageWithFileType:item.type scale:1];
            [self.scrollHeader push:item.name image:image];
        }
    }
    return didReload;
}

- (UIViewController *)pageWithItem:(HsFileBrowerItem *)item {
    if (item.isDir) {
        HsFileBrowerPage *filePage = [[HsFileBrowerPage alloc] init];
        filePage.delegate = self;
        [filePage reloadAtDirectoryWithItem:item];
        return filePage;
    } else if (item.type == HsFileBrowerFileTypePList) {
        Class plistBrowerPagCls = NSClassFromString(@"HsPlistBrowerPage");
        if (!plistBrowerPagCls) return nil;
        UIViewController *plistBrowerPage = [plistBrowerPagCls alloc];
        SEL initSelector = NSSelectorFromString(@"initWithPlistFilePath:");
        if (![plistBrowerPage respondsToSelector:initSelector]) return nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [plistBrowerPage performSelector:initSelector withObject:item.path];
#pragma clang diagnostic pop
        return plistBrowerPage;
#ifdef HSTESTTOOL_NEED_QUICKLOOK
    } else if (1 && [QLPreviewController canPreviewItem:item.url]) {
        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        return previewController;
#endif
    }
    return nil;
}

/// MARK: - layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGPoint topPoint = [self.view convertPoint:CGPointZero toView:[UIApplication sharedApplication].windows.firstObject];
    CGRect frame = self.scrollHeader.bounds;
    frame.origin.y = HsFileBrower_NavBarBottom - topPoint.y;
    self.headerToolBar.frame = frame;
    self.scrollHeader.frame = self.headerToolBar.bounds;
}

/// 设置头部路径视图是否隐藏
/// @param hidden 是否隐藏
/// @param animated 是否添加动画
- (void)setScrollHeaderHidden:(BOOL)hidden animated:(BOOL)animated {
    if (hidden) {
        if (self->_headerToolBar.alpha == 0.0f) return;
        CGFloat translation = [UIScreen mainScreen].bounds.size.width / 4;
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self->_headerToolBar.transform = CGAffineTransformMakeTranslation(-translation, 0);
                self->_headerToolBar.alpha = 0.0f;
            }];
        } else {
            self->_headerToolBar.transform = CGAffineTransformMakeTranslation(-translation, 0);
            self->_headerToolBar.alpha = 0.0f;
        }
    } else {
        if (self->_headerToolBar.alpha == 1.0f) return;
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self->_headerToolBar.transform = CGAffineTransformIdentity;
                self->_headerToolBar.alpha = 1.0f;
            }];
        } else {
            self->_headerToolBar.transform = CGAffineTransformIdentity;
            self->_headerToolBar.alpha = 1.0f;
        }
    }
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
        _scrollHeader = [HsFileBrowerScrollHeader viewWithextArray:nil imageArray:nil];
        _scrollHeader.backgroundColor = [UIColor clearColor];
        _scrollHeader.delegate = self;
    }
    return _scrollHeader;
}

/// MARK: - <UINavigationControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSInteger idx = [self.navigation.viewControllers indexOfObject:viewController];
    if (idx != NSNotFound) {
        // push
        /// 移除目录后面的路径
        [self.pathNavigation removeObjectsInRange:NSMakeRange(idx + 1, self.pathNavigation.count - idx - 1)];
        /// 头部移动到当前目录，
        [self.scrollHeader popToIndex:idx];
    } else {
        // pop
    }
    BOOL isFileBrowerPage = [viewController isKindOfClass:[HsFileBrowerPage class]];
    [self setScrollHeaderHidden:!isFileBrowerPage animated:animated];
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
    [self enterDirectoryWithItem:item];
}

#ifdef HSTESTTOOL_NEED_QUICKLOOK

/// MARK: - <QLPreviewControllerDataSource>

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return _currentItem.url ? 1 : 0;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return _currentItem.url;
}

#endif

@end
