//
//  ZZPlistBrowerPage.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/4.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZPlistBrowerPage.h"
#import "ZZTestToolDefine.h"
#import "ZZPlistBrowerSearchResultPage.h"
#import "ZZPlistBrowerNode.h"
#import "ZZPlistBrowerTableView.h"

@interface ZZPlistBrowerPage () <UISearchControllerDelegate, ZZPlistBrowerTableViewDelegate> {
    BOOL _showInRawText;
    NSString *_rawText;
    ZZPlistBrowerNode *_focusNode;
}

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ZZPlistBrowerSearchResultPage *searchResultController;

@property (nonatomic, strong) ZZPlistBrowerNode *rootNode;
@property (nonatomic, strong) ZZPlistBrowerTableView *browerTableView;
@property (nonatomic, strong) UITextView *rawTextView;

@end

@implementation ZZPlistBrowerPage

/// MARK: - init

/// 初始化方法
- (instancetype)init {
    if (self = [super init]) {}
    return self;
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
/// @param path 根结点文件（.plist）路径
- (instancetype)initWithPlistFilePath:(NSString *)path {
    if (self == [super init]) {
        [self setPath:path];
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
    CGPoint topPoint = [self.view convertPoint:CGPointZero toView:[UIApplication sharedApplication].windows.firstObject];
    CGFloat navigationBarBottom = ZZFileBrower_NavBarBottom;
    if (self.navigationController.isBeingPresented) {
        navigationBarBottom = 56;
    }
    CGFloat searBarBottom = navigationBarBottom + 52.0f;
    searBarBottom -= topPoint.y;
    self.browerTableView.frame = CGRectMake(0, searBarBottom, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - searBarBottom);
}

/// MARK: right bar button

- (void)setupBarButtonItem {
    if (_path) {
        if (_showInRawText) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Plist" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"XML" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
        }
    }
    if (self.navigationController.isBeingPresented) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(leftBarButtonItemAction:)];
    }
}

- (void)leftBarButtonItemAction:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)item {
    _showInRawText = !_showInRawText;
    if (_showInRawText) {
        if (!self.rawTextView.superview) {
            [self.view addSubview:self.rawTextView];
        }
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacChineseTrad);
        NSError *error;
        self.rawTextView.text = [NSString stringWithContentsOfFile:_path encoding:encoding error:&error];
        if (error) {
            [self alertWithTitle:@"" message:error.description];
        }
        self.rawTextView.hidden = NO;
        self.browerTableView.hidden = YES;
    } else {
        self.rawTextView.hidden = YES;
        self.browerTableView.hidden = NO;
    }
    [self setupBarButtonItem];
}

/// MARK: - load data

- (void)setObject:(id)object {
    if (_object == object) {
        return;
    }
    _object = object;
    _rootNode = [[ZZPlistBrowerNode alloc] initWithKey:@"Root" value:_object];
    self.browerTableView.rootNode = _rootNode;
    [self.browerTableView reloadData];
}

- (void)setPath:(NSString *)path {
    if ([_path isEqualToString:path]) {
        return;
    }
    _path = [path copy];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]) {
        id userList = [NSDictionary dictionaryWithContentsOfFile:_path];
        [self setObject:userList];
    }
}

/// MARK: - getter

- (ZZPlistBrowerTableView *)browerTableView {
    if (_browerTableView) {
        return _browerTableView;
    }
    _browerTableView = [[ZZPlistBrowerTableView alloc] init];
    _browerTableView.delegate = self;
    return _browerTableView;
}

- (UITextView *)rawTextView {
    if (_rawTextView) {
       return _rawTextView;
    }
    _rawTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _rawTextView.font = [UIFont systemFontOfSize:15.0f];
    return _rawTextView;
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

- (ZZPlistBrowerSearchResultPage *)searchResultController {
    if (_searchResultController) {
        return _searchResultController;
    }
    _searchResultController = [[ZZPlistBrowerSearchResultPage alloc] init];
    return _searchResultController;
}

/// MARK: - <UISearchControllerDelegate>

- (void)didPresentSearchController:(UISearchController *)searchController {
    ZZPlistBrowerNode *rootNode = [[ZZPlistBrowerNode alloc] initWithKey:nil value:_object];
    self.searchResultController.browerTableView.rootNode = rootNode;
}

/// MARK: - <ZZPlistBrowerTableViewDelegate>

/// 长按单元格代理
/// @param plsitTableView plist 视图
/// @param node 结点
/// @param location 在 plist 视图上的长按位置
- (void)plistTableView:(ZZPlistBrowerTableView *)plsitTableView
  didLongPressWithNode:(ZZPlistBrowerNode *)node
              location:(CGPoint)location {
    _focusNode = node;
    [self showMenuControllerAtPoint:[plsitTableView convertPoint:location toView:self.view]];
}

- (void)showMenuControllerAtPoint:(CGPoint)location {
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *cutItem = [[UIMenuItem alloc] initWithTitle:@"剪切" action:@selector(_copyKey:)];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"粘贴" action:@selector(_copyKey:)];
    UIMenuItem *addRowItem = [[UIMenuItem alloc] initWithTitle:@"添加" action:@selector(_addRow:)];
    UIMenuItem *editItem = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(_createDirectory:)];
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(_createDirectory:)];
    UIMenuItem *copyKeyValueItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(_copyKey:)];
    UIMenuItem *copyKeyItem = [[UIMenuItem alloc] initWithTitle:@"复制键" action:@selector(_copyKey:)];
    UIMenuItem *copyValueItem = [[UIMenuItem alloc] initWithTitle:@"复制值" action:@selector(_copyValue:)];
    //UIMenuItem *editItem = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(_paste:)];
    menu.menuItems = @[
        cutItem,
        copyItem,
        addRowItem,
        editItem,
        deleteItem,
        copyKeyValueItem,
        copyKeyItem,
        copyValueItem,
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
    if (action == @selector(_copyKey:) ||
        action == @selector(_copyValue:) ||
        action == @selector(_addRow:) ||
        //action == @selector(_selectAll:) ||
        //action == @selector(_showBrief:) ||
        action == @selector(_createDirectory:)) {
        return YES;
    }
    return NO;
}

- (void)_copyKey:(UIMenuController *)menu {
    if (_focusNode) {
        [UIPasteboard generalPasteboard].string = _focusNode.key;
    }
}

- (void)_copyValue:(UIMenuController *)menu {
    if (_focusNode) {
        [UIPasteboard generalPasteboard].string = _focusNode.value;
    }
}

- (void)_paste:(UIMenuController *)menu {
    
}

- (void)_addRow:(UIMenuController *)menu {
    
}

- (void)_selectAll:(UIMenuController *)menu {
    
}

- (void)_createDirectory:(UIMenuController *)menu {
    
}

- (void)_showBrief:(UIMenuController *)menu {
    
}

@end
