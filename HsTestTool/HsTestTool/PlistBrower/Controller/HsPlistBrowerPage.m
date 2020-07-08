//
//  HsPlistBrowerPage.m
//  HsBusinessEngine
//
//  Created by ZZ on 2020/6/4.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsPlistBrowerPage.h"
#import "HsTestToolDefine.h"
#import "HsPlistBrowerSearchResultPage.h"
#import "HsPlistBrowerNode.h"
#import "HsPlistBrowerTableView.h"

@interface HsPlistBrowerPage () <UISearchControllerDelegate, HsPlistBrowerTableViewDelegate> {
    BOOL _showInRawString;
}

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) HsPlistBrowerSearchResultPage *searchResultController;

@property (nonatomic, strong) HsPlistBrowerNode *rootNode;
@property (nonatomic, strong) HsPlistBrowerTableView *browerTableView;

@end

@implementation HsPlistBrowerPage

/// MARK: - init

+ (id)createPage:(NSDictionary*)params {
    HsPlistBrowerPage *page = nil;
    if (params[HsPlistBrowerPageObjectCreateKey]) {
        page = [[HsPlistBrowerPage alloc] initWithObject:params[HsPlistBrowerPageObjectCreateKey]];
    } else if (params[HsPlistBrowerPagePlsitFilePathCreateKey]) {
        page = [[HsPlistBrowerPage alloc] initWithPlistFilePath:params[HsPlistBrowerPagePlsitFilePathCreateKey]];
    } else {
        page = [[HsPlistBrowerPage alloc] init];
    }
    return page;
}

/// 初始化方法
/// @param anObject 基本类型数据，如NSArray、NSDictionary、NSString、NSNumber、NSData等
- (instancetype)initWithObject:(id)anObject {
    if (self == [super init]) {
        [self setObject:anObject];
    }
    return self;
}

/// 初始化方法
/// @param path plist文件路径
- (instancetype)initWithPlistFilePath:(NSString *)path {
    if (self == [super init]) {
        _path = [path copy];
        id userList = [NSDictionary dictionaryWithContentsOfFile:_path];
        [self setObject:userList];
    }
    return self;
}

/// MARK: - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Plist";
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupBarButtonItem];
    [self.view addSubview:self.browerTableView];
    if (@available(iOS 10.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        [self.view addSubview:self.searchController.searchBar];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat navigationBarBottom = HsFileBrower_NavBarBottom;
    if (self.navigationController.isBeingPresented) {
        navigationBarBottom = 56;
    }
    CGFloat searBarBottom = navigationBarBottom + 52.0f;
    self.browerTableView.frame = CGRectMake(0, searBarBottom, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - searBarBottom);
}

/// MARK: right bar button

- (void)setupBarButtonItem {
    if (_showInRawString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Plist" style:(UIBarButtonItemStylePlain) target:self action:@selector(testData)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"XML" style:(UIBarButtonItemStylePlain) target:self action:@selector(testData)];
    }
    if (self.navigationController.isBeingPresented) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(leftBarButtonItemAction:)];
    }
}

- (void)leftBarButtonItemAction:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)item {
    _showInRawString = !_showInRawString;
    [self setupBarButtonItem];
}

/// MARK: - load data

- (void)testData {
//    // 设定pList文件路径
//    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"JF-info.plist.encode" ofType:nil];
//    id userList = [NSDictionary dictionaryWithContentsOfFile:dataPath];
//    if (!userList) {
//        dataPath = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
//        userList = [NSDictionary dictionaryWithContentsOfFile:dataPath];
//    }
    
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
    id userList = [NSDictionary dictionaryWithContentsOfFile:dataPath];
    [self setObject:userList];
}

- (void)setObject:(id)object {
    if (_object == object) {
        return;
    }
    _object = object;
    _rootNode = [[HsPlistBrowerNode alloc] initWithKey:nil value:_object];
    self.browerTableView.rootNode = _rootNode;
    [self.browerTableView reloadData];
}

/// MARK: - getter

- (HsPlistBrowerTableView *)browerTableView {
    if (_browerTableView) {
        return _browerTableView;
    }
    _browerTableView = [[HsPlistBrowerTableView alloc] init];
    _browerTableView.delegate = self;
    return _browerTableView;
}

- (UISearchController *)searchController {
    if (_searchController) {
        return _searchController;
    }
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    self.searchResultController.searchController = _searchController;
    [_searchController.searchBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    _searchController.delegate = self;
    _searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchController.searchResultsUpdater = self.searchResultController;
    self.definesPresentationContext = YES;
    return _searchController;
}

- (HsPlistBrowerSearchResultPage *)searchResultController {
    if (_searchResultController) {
        return _searchResultController;
    }
    _searchResultController = [[HsPlistBrowerSearchResultPage alloc] init];
    return _searchResultController;
}

/// MARK: - <UISearchControllerDelegate>

- (void)didPresentSearchController:(UISearchController *)searchController {
    HsPlistBrowerNode *rootNode = [[HsPlistBrowerNode alloc] initWithKey:nil value:_object];
    self.searchResultController.browerTableView.rootNode = rootNode;
}

/// MARK: - <HsPlistBrowerTableViewDelegate>

/// 长按单元格代理
/// @param plsitTableView plist 视图
/// @param node 结点
/// @param location 在 plist 视图上的长按位置
- (void)plistTableView:(HsPlistBrowerTableView *)plsitTableView
  didLongPressWithNode:(HsPlistBrowerNode *)node
              location:(CGPoint)location {
    [self showMenuControllerAtPoint:[plsitTableView convertPoint:location toView:self.view]];
}

- (void)showMenuControllerAtPoint:(CGPoint)location {
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *pasteItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(_paste:)];
    UIMenuItem *editItem = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(_paste:)];
    UIMenuItem *createDirItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(_createDirectory:)];
    menu.menuItems = @[
        pasteItem,
        editItem,
        createDirItem,
    ];
    if (@available(iOS 13.0, *)) {
        [menu showMenuFromView:self.view rect:CGRectMake(location.x, location.y, 0, 0)];
    } else {
        [menu setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:self.view];
    }
}

- (BOOL)canBecomeFirstResponder {
    [super canBecomeFirstResponder];
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(_paste:) ||
        action == @selector(_selectAll:) ||
        action == @selector(_showBrief:) ||
        action == @selector(_createDirectory:)) {
        return YES;
    }
    return NO;
}

- (void)_paste:(UIMenuController *)menu {
    
}

- (void)_selectAll:(UIMenuController *)menu {
    
}

- (void)_createDirectory:(UIMenuController *)menu {
    
}

- (void)_showBrief:(UIMenuController *)menu {
    
}




@end
