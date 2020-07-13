//
//  HsConfigBrowerPage.m
//  HsTestTool
//
//  Created by handsome on 2020/7/13.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "HsConfigBrowerPage.h"
#import "HsTestToolDefine.h"
#import "HsConfigBrowerPlistPage.h"
#import "HsConfigBrowerHeaderView.h"

@interface HsConfigBrowerPage () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) UIToolbar *headerToolBar; // 顶部滑动父视图
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) HsConfigBrowerHeaderView *headerView;

@end

@implementation HsConfigBrowerPage

/// MARK: - init

- (instancetype)init {
    if (self = [super init]) {}
    return self;
}

/// 初始化方法
/// @param objectDict 基本类型数据字典，如NSArray、NSDictionary、NSString、NSNumber、NSData等
- (instancetype)initWithObjectsDictionary:(NSDictionary<NSString *, id> *)objectDict {
    if (self = [super init]) {
        [self setObjectDict:objectDict];
    }
    return self;
}

/// MARK: - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HsConfig";
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.headerToolBar];
    [self.headerToolBar addSubview:self.searchBar];
    [self.headerToolBar addSubview:self.headerView];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setObjectDict:(NSDictionary<NSString *, id> *)objectDict {
    if ([_objectDict isEqualToDictionary:objectDict]) {
        return;
    }
    _objectDict = objectDict;
    [self.headerView setTextArray:_objectDict.allKeys];
}

/// MARK: - layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGPoint topPoint = [self.view convertPoint:CGPointZero toView:[UIApplication sharedApplication].windows.firstObject];
    self.searchBar.frame = CGRectMake(16, 0, kScreenWidth - 32, 49);
    
    CGRect frame = self.headerView.bounds;
    frame.origin.y = HsFileBrower_NavBarBottom - topPoint.y;
    frame.size.height += CGRectGetHeight(self.searchBar.frame);
    self.headerToolBar.frame = frame;

    frame = self.headerView.frame;
    frame.origin.y = CGRectGetMaxY(self.searchBar.frame);
    self.headerView.frame = frame;
}

/// MARK: - getter

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

- (UISearchBar *)searchBar {
    if (_searchBar) {
        return _searchBar;
    }
    _searchBar = [[UISearchBar alloc] init];
    
    return _searchBar;
}

- (HsConfigBrowerHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [HsConfigBrowerHeaderView viewWithextArray:nil];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIPageViewController *)pageViewController {
    if(!_pageViewController){
        //书脊位置，只有在UIPageViewControllerTransitionStylePageCurl才生效
        NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        
        //两个page之间的间距，只有UIPageViewControllerTransitionStyleScroll格式才生效
        //        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:0]
        //                                                           forKey: UIPageViewControllerOptionInterPageSpacingKey];
        _pageViewController = [[ UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.view.backgroundColor = [UIColor clearColor];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
    
}

/// MARK: - <UIPageViewControllerDataSource>

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}

@end
