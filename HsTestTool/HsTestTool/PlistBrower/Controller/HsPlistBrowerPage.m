//
//  HsPlistBrowerPage.m
//  HsBusinessEngine
//
//  Created by ZZ on 2020/6/4.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsPlistBrowerPage.h"
#import "HsPlistBrowerSearchResultPage.h"
#import "HsPlistBrowerNode.h"
#import "HsPlistBrowerTableView.h"

@interface HsPlistBrowerPage () <UISearchControllerDelegate> {
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
    if (@available(iOS 10.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupRightBarButtonItem];
    [self.view addSubview:self.browerTableView];
    [self.view addSubview:self.searchController.searchBar];
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    //[self testData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UISearchBar *searchBar = self.searchController.searchBar;
    CGFloat searBarBottom = 0;
    if (searchBar) {
        CGRect rect = [searchBar convertRect:searchBar.frame toView:self.view];
        searBarBottom = CGRectGetMaxY(rect);
    }
    self.searchController.searchBar.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight([UINavigationBar appearance].bounds) + CGRectGetHeight(searchBar.bounds) / 2);
    self.browerTableView.frame = CGRectMake(0, searBarBottom, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - searBarBottom);
}

/// MARK: right bar button

- (void)setupRightBarButtonItem {
    if (_showInRawString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Plist" style:(UIBarButtonItemStylePlain) target:self action:@selector(testData)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"XML" style:(UIBarButtonItemStylePlain) target:self action:@selector(testData)];
    }
}

- (void)rightBarButtonItemAction:(UIBarButtonItem *)item {
    _showInRawString = !_showInRawString;
    [self setupRightBarButtonItem];
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

@end
