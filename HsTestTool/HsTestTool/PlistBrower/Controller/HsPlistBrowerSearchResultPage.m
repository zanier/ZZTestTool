//
//  HsPlistBrowerSearchResultPage.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/22.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsPlistBrowerSearchResultPage.h"
#import "HsPlistBrowerTableView.h"
#import "HsPlistBrowerNode.h"

@interface HsPlistBrowerSearchResultPage ()

@property (nonatomic, strong) HsPlistBrowerTableView *browerTableView;

@end

@implementation HsPlistBrowerSearchResultPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.browerTableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat searBarBottom = 0;
    if (_searchController) {
        CGRect rect = [_searchController.searchBar convertRect:_searchController.searchBar.frame toView:self.view];
        searBarBottom = CGRectGetMaxY(rect);
    }
    self.browerTableView.frame = CGRectMake(0, searBarBottom, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - searBarBottom);
}

/// MARK: - getter

- (HsPlistBrowerTableView *)browerTableView {
    if (_browerTableView) {
        return _browerTableView;
    }
    _browerTableView = [[HsPlistBrowerTableView alloc] init];
    return _browerTableView;
}

/// MARK: - setter

- (void)setObject:(id)object {
    if (_object == object) {
        return;
    }
    _object = object;
    HsPlistBrowerNode *rootNode = [[HsPlistBrowerNode alloc] initWithKey:nil value:_object];
    self.browerTableView.rootNode = rootNode;
    [self.browerTableView reloadData];
}
//- (void)setRootNode:(HsPlistBrowerNode *)rootNode {
//    self.browerTableView.rootNode = rootNode;
//}

/// MARK: - <UISearchResultsUpdating>

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    searchController.searchResultsController.view.hidden = NO;
    [self.browerTableView searchText:searchText];
}

@end
