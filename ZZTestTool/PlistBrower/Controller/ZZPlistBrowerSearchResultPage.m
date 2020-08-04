//
//  ZZPlistBrowerSearchResultPage.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/22.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZPlistBrowerSearchResultPage.h"
#import "ZZPlistBrowerTableView.h"
#import "ZZPlistBrowerNode.h"
#import "ZZTestToolDefine.h"

@interface ZZPlistBrowerSearchResultPage ()

@property (nonatomic, strong) ZZPlistBrowerTableView *browerTableView;

@end

@implementation ZZPlistBrowerSearchResultPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.browerTableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGPoint topPoint = [self.view convertPoint:CGPointZero toView:[UIApplication sharedApplication].windows.firstObject];
    CGFloat searBarBottom = ZZFileBrower_StatusBarHeight + ZZFileBrower_SearchBarHeight;
    if (self.navigationController.isBeingPresented) {
        searBarBottom = ZZFileBrower_SearchBarHeight;
    }
    searBarBottom -= topPoint.y;
    self.browerTableView.frame = CGRectMake(0, searBarBottom, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - searBarBottom);
}

/// MARK: - getter

- (ZZPlistBrowerTableView *)browerTableView {
    if (_browerTableView) {
        return _browerTableView;
    }
    _browerTableView = [[ZZPlistBrowerTableView alloc] initWithFrame:self.view.bounds];
    return _browerTableView;
}

/// MARK: - setter

- (void)setObject:(id)object {
    if (_object == object) {
        return;
    }
    _object = object;
    ZZPlistBrowerNode *rootNode = [[ZZPlistBrowerNode alloc] initWithKey:nil value:_object];
    self.browerTableView.rootNode = rootNode;
    [self.browerTableView reloadData];
}

/// MARK: - <UISearchResultsUpdating>

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    searchController.searchResultsController.view.hidden = NO;
    [self.browerTableView searchText:searchText];
}

@end
