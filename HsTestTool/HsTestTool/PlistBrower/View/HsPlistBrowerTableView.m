//
//  HsPlistBrowerTableView.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/22.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsPlistBrowerTableView.h"
#import "HsPlistBrowerNodeView.h"
#import "HsPlistBrowerPageCell.h"
#import "HsPlistBrowerNode.h"

static const CGFloat HsPlistBrowerPageIndentationWidth = 18.0f;

static const CGFloat HsPlistBrowerPageTypeViewWidth = 90.0f;

@interface HsPlistBrowerTableView () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat _maxWidthThatFit;
}

@property (nonatomic, strong) NSMutableArray<HsPlistBrowerNode *> *dataSource;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) HsPlistBrowerNodeView *nodeView;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, strong) NSPredicate *predicate;

@end

@implementation HsPlistBrowerTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:self.tableView];
    [self addSubview:self.scrollView];
    [self addSubview:self.typeTableView];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.typeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat typeWidth = HsPlistBrowerPageTypeViewWidth;
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    // scrollView
    self.scrollView.frame = CGRectMake(0, 0, selfWidth - typeWidth, CGRectGetHeight(self.bounds));
    // typeTableView
    self.typeTableView.frame = CGRectMake(selfWidth - typeWidth, 0, typeWidth, CGRectGetHeight(self.scrollView.bounds));
    // tableView
    if (_maxWidthThatFit == 0) {
        _maxWidthThatFit = CGRectGetWidth(self.scrollView.frame);
    }
    self.tableView.frame = CGRectMake(0, 0, _maxWidthThatFit, CGRectGetHeight(self.scrollView.bounds));
    self.scrollView.contentSize = CGSizeMake(_maxWidthThatFit, 0);
}

/// MARK: - getter

- (UIScrollView *)scrollView {
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeZero;
    return _scrollView;
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.tableFooterView = [[UIView alloc] init];
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    return _tableView;
}

- (UITableView *)typeTableView {
    if (_typeTableView) {
        return _typeTableView;
    }
    _typeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _typeTableView.dataSource = self;
    _typeTableView.delegate = self;
    _typeTableView.tableFooterView = [[UIView alloc] init];
    _typeTableView.backgroundColor = UIColor.clearColor;
    //_typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _typeTableView.allowsSelection = NO;
    return _typeTableView;
}

- (HsPlistBrowerNodeView *)nodeView {
    if (_nodeView) {
        return _nodeView;
    }
    _nodeView = [[HsPlistBrowerNodeView alloc] initWithFrame:CGRectMake(18, 800, 375 - 36, 150)];
    [self addSubview:_nodeView];
    return _nodeView;
}

- (NSMutableArray<HsPlistBrowerNode *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

/// MARK: - setter

- (void)setRootNode:(HsPlistBrowerNode *)rootNode {
    if (_rootNode == rootNode) {
        return;
    }
    _rootNode = rootNode;
    if (self.dataSource.count == 0) {
        if (_rootNode) {
            [self.dataSource addObject:_rootNode];
        }
    }
    [self reloadData];
    // 默认展开根结点
    if (!_rootNode.isExpanded) {
        [self changeNodeExpanded:_rootNode];
    }
}

- (void)reloadData {
    [self.tableView reloadData];
    [self.typeTableView reloadData];
}

/// MARK: - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cell";
    if (tableView == self.typeTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HsPlistBrowerPageTypeViewWidth - 10, 44)];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:12.0];
            label.textAlignment = NSTextAlignmentRight;
            label.tag = 123;
            [cell.contentView addSubview:label];
            cell.backgroundColor = self.backgroundColor;
            cell.separatorInset = UIEdgeInsetsZero;
        }
        UILabel *label = [cell.contentView viewWithTag:123];
        label.text = self.dataSource[indexPath.row].typeString;
        return cell;
    } else {
        HsPlistBrowerPageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            cell = [[HsPlistBrowerPageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
            cell.indentationWidth = HsPlistBrowerPageIndentationWidth;
            cell.backgroundColor = self.backgroundColor;
        }
        cell.node = self.dataSource[indexPath.row];
        // 高亮选择文本
        if (_searchText) {
            [cell highlightSearchText:_searchText];
        }
        return cell;
    }
}

/// MARK: - <UITableViewDelegate>

/// 同步两个 tableView 的偏移量
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        _typeTableView.contentOffset = _tableView.contentOffset;
    } else if (scrollView == _typeTableView) {
        _tableView.contentOffset = _typeTableView.contentOffset;
    }
}

/// 点击单元格，展开或收起结点
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 选择
    [self changeNodeExpanded:self.dataSource[indexPath.row]];
    // 重绘三角形
    [[tableView cellForRowAtIndexPath:indexPath] setNeedsDisplay];
    
//    self.nodeView.node = self.dataSource[indexPath.row];
//    [self.nodeView showAtView:self animated:YES];
    
//    static BOOL issi = NO;
//    if (issi) {
//        [self.nodeView showAtView:self animated:YES];
//    } else {
//        [self.nodeView hideAnimated:YES];
//    }
//    issi = !issi;
    
}

/// 切换指定结点的展开状态
/// @param node 结点
- (void)changeNodeExpanded:(HsPlistBrowerNode *)node {
    if (!node) return;
    NSInteger loc = [self.dataSource indexOfObject:node];
    [self changeNodeExpandedAtIndex:loc];
}

/// 切换指定位置结点的展开状态
/// @param index 结点的位置
- (void)changeNodeExpandedAtIndex:(NSInteger)index {
    if (index >= self.dataSource.count) return;
    HsPlistBrowerNode *node = [self.dataSource objectAtIndex:index];
    NSLog(@"didSelect %@", node);
    NSArray<HsPlistBrowerNode *> *visiableChildren = [node visiableChildren];
    // 反转状态
    node.expanded = !node.expanded;
    if (!node.expanded) {
        // 收起结点
        // 安全性判断
        if (self.dataSource.count < index + 1 + visiableChildren.count) {
            return;
        }
        [self.dataSource removeObjectsInRange:NSMakeRange(index + 1, visiableChildren.count)];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:visiableChildren.count];
        for (int i = 0; i < visiableChildren.count; i++) {
            // indexPath
            [array addObject:[NSIndexPath indexPathForRow:index + 1 + i inSection:0]];
        }
        // animation
        [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:(UITableViewRowAnimationTop)];
        [self.typeTableView deleteRowsAtIndexPaths:array withRowAnimation:(UITableViewRowAnimationTop)];
    } else {
        // 展开结点
        if (index == self.dataSource.count - 1) {
            [self.dataSource addObjectsFromArray:visiableChildren];
        } else {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index + 1, visiableChildren.count)];
            [self.dataSource insertObjects:visiableChildren atIndexes:indexSet];
        }
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:visiableChildren.count];
        CGFloat maxWidthThatFit = 0;
        for (int i = 0; i < visiableChildren.count; i++) {
            // indexPath
            [array addObject:[NSIndexPath indexPathForRow:index + 1 + i inSection:0]];
            // width
            if (maxWidthThatFit < visiableChildren[i].widthThatFit) {
                maxWidthThatFit = visiableChildren[i].widthThatFit;
            }
        }
        // animation
        [self.tableView insertRowsAtIndexPaths:array withRowAnimation:(UITableViewRowAnimationBottom)];
        [self.typeTableView insertRowsAtIndexPaths:array withRowAnimation:(UITableViewRowAnimationBottom)];
        // 增加宽度以完全展示标题
        /// cell 缩进
        maxWidthThatFit += 15 + (node.depth + 1) * HsPlistBrowerPageIndentationWidth + 15;
        maxWidthThatFit += 20;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        maxWidthThatFit = maxWidthThatFit < screenWidth ? screenWidth : maxWidthThatFit;
        if (_maxWidthThatFit < maxWidthThatFit) {
            _maxWidthThatFit = maxWidthThatFit;
            [self setNeedsLayout];
        }
    }
}

/// MARK: - search

- (void)searchText:(NSString *)text {
    if (!text || text.length == 0) {
        [_dataSource removeAllObjects];
        [self reloadData];
        return;
    }
    _searchText = [text copy];
    _predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", text];
    NSMutableArray<HsPlistBrowerNode *> *array = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    [self recursiveScanWithArray:array node:_rootNode];
    _dataSource = array;
    [self reloadData];
}

- (void)recursiveScanWithArray:(NSMutableArray<HsPlistBrowerNode *> *)array node:(HsPlistBrowerNode *)node {
    node.visiable = NO;
    NSInteger index = array.count;
    for (HsPlistBrowerNode *child in node.children) {
        [self recursiveScanWithArray:array node:child];
    }
    BOOL isEligibleNode = [self isEligibleNode:node searchText:_searchText];
    BOOL hasEligibleChild = index < array.count;
    if (hasEligibleChild || isEligibleNode) {
        if (hasEligibleChild) {
            node.expanded = YES;
        }
        node.visiable = YES;
        [array insertObject:node atIndex:index];
    }
}

- (BOOL)isEligibleNode:(HsPlistBrowerNode *)node searchText:(NSString *)text {
    if ([node.key isKindOfClass:[NSString class]]) {
        if ([_predicate evaluateWithObject:node.key]) return YES;
    }
    if ([node.value isKindOfClass:[NSString class]]) {
        if ([_predicate evaluateWithObject:node.value]) return YES;
    }
    return NO;
}

@end
