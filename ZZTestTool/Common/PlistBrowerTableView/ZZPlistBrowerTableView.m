//
//  ZZPlistBrowerTableView.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/22.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZPlistBrowerTableView.h"
#import "ZZPlistBrowerNodeView.h"
#import "ZZPlistBrowerPageCell.h"
#import "ZZPlistBrowerNode.h"

static const CGFloat ZZPlistBrowerPageIndentationWidth = 18.0f;

static const CGFloat ZZPlistBrowerPageTypeViewWidth = 90.0f;

@interface ZZPlistBrowerTableView () <UITableViewDataSource, UITableViewDelegate> {
    CGFloat _maxWidthThatFit;
}

@property (nonatomic, strong) NSMutableArray<ZZPlistBrowerNode *> *dataSource;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, strong) ZZPlistBrowerNodeView *nodeView;

@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, strong) NSPredicate *predicate;

@end

@implementation ZZPlistBrowerTableView

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
    CGFloat typeWidth = ZZPlistBrowerPageTypeViewWidth;
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
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
    _tableView.rowHeight = 45.0f;
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
    _typeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
    _typeTableView.backgroundColor = UIColor.clearColor;
    _typeTableView.rowHeight = 45.0f;
    _typeTableView.allowsSelection = NO;
    return _typeTableView;
}

- (ZZPlistBrowerNodeView *)nodeView {
    if (_nodeView) {
        return _nodeView;
    }
    _nodeView = [[ZZPlistBrowerNodeView alloc] initWithFrame:CGRectMake(18, 800, 375 - 36, 150)];
    [self addSubview:_nodeView];
    return _nodeView;
}

- (NSMutableArray<ZZPlistBrowerNode *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

/// MARK: - setter

- (void)setRootNode:(ZZPlistBrowerNode *)rootNode {
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
    if (tableView == self.tableView) {
        ZZPlistBrowerPageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            cell = [[ZZPlistBrowerPageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
            cell.indentationWidth = ZZPlistBrowerPageIndentationWidth;
            cell.backgroundColor = self.backgroundColor;
            /// long press
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressAction:)];
            [cell.contentView addGestureRecognizer:longPress];
        }
        cell.node = self.dataSource[indexPath.row];
        // 高亮选择文本
        if (_searchText) {
            [cell highlightSearchText:_searchText];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ZZPlistBrowerPageTypeViewWidth - 10, 44)];
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
- (void)changeNodeExpanded:(ZZPlistBrowerNode *)node {
    if (!node) return;
    NSInteger loc = [self.dataSource indexOfObject:node];
    [self changeNodeExpandedAtIndex:loc];
}

/// 切换指定位置结点的展开状态
/// @param index 结点的位置
- (void)changeNodeExpandedAtIndex:(NSInteger)index {
    if (index >= self.dataSource.count) return;
    ZZPlistBrowerNode *node = [self.dataSource objectAtIndex:index];
    NSLog(@"didSelect %@", node);
    NSArray<ZZPlistBrowerNode *> *visiableChildren = [node visiableChildren];
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
        maxWidthThatFit += 15 + (node.depth + 1) * ZZPlistBrowerPageIndentationWidth + 15;
        maxWidthThatFit += 20;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        maxWidthThatFit = maxWidthThatFit < screenWidth ? screenWidth : maxWidthThatFit;
        if (_maxWidthThatFit < maxWidthThatFit) {
            _maxWidthThatFit = maxWidthThatFit;
            [self setNeedsLayout];
        }
    }
}

/// long press

- (void)cellLongPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(plistTableView:didLongPressWithNode:location:)]) {
            UITableViewCell *cell = (UITableViewCell *)longPress.view;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            ZZPlistBrowerNode *node = self.dataSource[indexPath.row];
            CGPoint location = [longPress locationInView:self];
            [_delegate plistTableView:self didLongPressWithNode:node location:location];
        }
    }
}

/// MARK: - search

/// 根据搜索字符串筛选显示结点
/// @param text 搜索字符串
- (void)searchText:(NSString *)text {
    if (!text || text.length == 0) {
        [_dataSource removeAllObjects];
        [self reloadData];
        return;
    }
    _searchText = [text copy];
    _predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", text];
    NSMutableArray<ZZPlistBrowerNode *> *array = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    [self recursiveScanWithArray:array node:_rootNode];
    _dataSource = array;
    [self reloadData];
}

- (void)recursiveScanWithArray:(NSMutableArray<ZZPlistBrowerNode *> *)array node:(ZZPlistBrowerNode *)node {
    node.visiable = NO;
    NSInteger index = array.count;
    for (ZZPlistBrowerNode *child in node.children) {
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

- (BOOL)isEligibleNode:(ZZPlistBrowerNode *)node searchText:(NSString *)text {
    if ([node.key isKindOfClass:[NSString class]]) {
        if ([_predicate evaluateWithObject:node.key]) return YES;
    }
    if ([node.value isKindOfClass:[NSString class]]) {
        if ([_predicate evaluateWithObject:node.value]) return YES;
    }
    return NO;
}

@end
