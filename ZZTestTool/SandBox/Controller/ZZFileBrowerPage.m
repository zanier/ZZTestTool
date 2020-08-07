//
//  ZZFileBrowerPageViewController.m
//  HsBusinessEngine
//
//  Created by zanier on 2020/6/4.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZFileBrowerPage.h"
#import "ZZTestToolDefine.h"
#import "ZZFileBrowerManager.h"
#import "ZZFileBrowerScrollHeader.h"
#import "ZZFileBrowerItem.h"
#import "ZZFileBrowerItemCell.h"
#import "ZZFileBrowerActionPage.h"
#import "ZZFileBrowerBriefPage.h"
#import "ZZFileBrowerAnimatedTransitioning.h"
#import "ZZFileBrowerNavigateTransitioning.h"
#import <AudioToolBox/AudioServices.h>

@interface ZZFileBrowerPage () <UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate, ZZFileBrowerItemCellDelegate, ZZFileBrowerActionPageDelegate, UINavigationControllerDelegate> {
    BOOL _isSelecting;
    UICollectionViewFlowLayout *_layout;
}

@property (nonatomic, strong) NSMutableArray<ZZFileBrowerItem *> *pathNavigation;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UILabel *emptylabel;

@end

@implementation ZZFileBrowerPage

/// MARK: - init

- (instancetype)initWithItem:(ZZFileBrowerItem *)item delegate:(id <ZZFileBrowerPageDelegate>)delegate {
    if (self = [super init]) {
        _item = item;
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithItem:(ZZFileBrowerItem *)item {
    if (self = [super init]) {
        _item = item;
    }
    return self;
}

/// MARK: - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviBarItem];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    [self.view addGestureRecognizer:longPress];
    

    [self.view addSubview:self.collectionView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGPoint topPoint = [self.view convertPoint:CGPointZero toView:[UIApplication sharedApplication].windows.firstObject];
    CGFloat scrollBottom = ZZFileBrower_NavBarBottom + [ZZFileBrowerScrollHeader defaultHeight];
    scrollBottom -= topPoint.y;
    self.collectionView.frame = CGRectMake(0, scrollBottom, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - scrollBottom);
    _emptyView.frame = self.collectionView.bounds;
    _emptylabel.center = _emptyView.center;
}

- (void)setItem:(ZZFileBrowerItem *)item {
    if (_item != item) {
        _item = item;
        [self reloadAtDirectoryWithItem:_item];
    }
}

- (void)setupNaviBarItem {
    if (!_isSelecting) {
        UIImage *moreBtnImage = [NSBundle hs_imageNamed:@"icon_barBtn_more@2x" type:@"png" inDirectory:nil];
        UIButton *barButton = [UIButton buttonWithType:UIButtonTypeSystem];
        barButton.tintColor = [UIColor systemBlueColor];
        barButton.frame = CGRectMake(200, 200, 25, 25);
        [barButton setImage:moreBtnImage forState:UIControlStateNormal];
        [barButton addTarget:self action:@selector(presentPopoverWithRightButton:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_selectDone)];
    }
}


/// 刷新显示指定文件夹下的文件，返回是否刷新
/// @param item 文件夹数据
- (void)reloadAtDirectoryWithItem:(ZZFileBrowerItem *)item {
    _item = item;
    [self setTitle:_item.name];
    NSString *path = item.path;
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        if (!isDir) return;
        _item.children = [ZZFileBrowerManager contentItemsOfItem:_item].mutableCopy;
        [self.collectionView reloadData];
    }
    BOOL isEmptyDataSource = (!_item.children || _item.children == 0);
    if (isEmptyDataSource) {
        if (!self.emptyView.superview) {
            [self.collectionView addSubview:self.emptyView];
        }
    }
    _emptyView.hidden = !isEmptyDataSource;
}

/// MARK: - right barbutton action

- (void)presentPopoverWithRightButton:(UIButton *)button {
    NSArray *dataSource = @[
        @[
            ZZFileBrowerActionPage_Select,
            ZZFileBrowerActionPage_Mkdir,
        ],
        @[
            ZZFileBrowerActionPage_SortByName,
            ZZFileBrowerActionPage_SortByDate,
            ZZFileBrowerActionPage_SortBySize,
            ZZFileBrowerActionPage_SortByType,
        ],
    ];
    ZZFileBrowerActionPage *actionPage = [[ZZFileBrowerActionPage alloc] initWithItem:_item actionNames:dataSource sourceView:button];
    actionPage.delegate = self;
    actionPage.modalPresentationStyle = UIModalPresentationPopover;
    actionPage.popoverPresentationController.delegate = self;
    actionPage.popoverPresentationController.sourceView = button;
    actionPage.popoverPresentationController.sourceRect = button.bounds;
    actionPage.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    if (@available(iOS 9.0, *)) {
        actionPage.popoverPresentationController.canOverlapSourceViewRect = NO;
    } else {
        // Fallback on earlier versions
    }
    [self presentViewController:actionPage animated:YES completion:nil];
}


/// MARK: - view long press action

/// 长按操作
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [longPress locationInView:self.view];
        [self showMenuControllerAtPoint:location];
    }
}

/// 长按弹出菜单
- (void)showMenuControllerAtPoint:(CGPoint)location {
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *pasteItem = [[UIMenuItem alloc] initWithTitle:@"粘贴" action:@selector(_paste)];
    UIMenuItem *createDirItem = [[UIMenuItem alloc] initWithTitle:@"新建文件夹" action:@selector(_createDirectory)];
    UIMenuItem *selectAllItem = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(_selectAll)];
    UIMenuItem *briefItem = [[UIMenuItem alloc] initWithTitle:@"简介" action:@selector(_showBrief)];
    UIMenuItem *reloadItem = [[UIMenuItem alloc] initWithTitle:@"刷新" action:@selector(_reload)];
    menu.menuItems = @[pasteItem, createDirItem, selectAllItem, briefItem, reloadItem];
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
    if (action == @selector(_paste) ||
        action == @selector(_selectAll) ||
        action == @selector(_showBrief) ||
        action == @selector(_reload) ||
        action == @selector(_createDirectory)) {
        return YES;
    }
    return NO;
}

/// MARK: - item long press action

- (void)presentFileActionWithItem:(ZZFileBrowerItem *)item fromCell:(ZZFileBrowerItemCell *)cell {
    NSArray *dataSource;
    if (!item.isDir) {
        dataSource = @[
            @[
                ZZFileBrowerActionPage_Copy,
                ZZFileBrowerActionPage_Duplicate,
                ZZFileBrowerActionPage_Move,
                ZZFileBrowerActionPage_Delete,
            ],
            @[
                ZZFileBrowerActionPage_Brief,
                ZZFileBrowerActionPage_Rename,
            ],
            @[
                ZZFileBrowerActionPage_Share,
            ],
        ];
    } else {
        dataSource = @[
            @[
                ZZFileBrowerActionPage_Copy,
                ZZFileBrowerActionPage_Duplicate,
                ZZFileBrowerActionPage_Move,
                ZZFileBrowerActionPage_Delete,
            ],
            @[
                ZZFileBrowerActionPage_Brief,
                ZZFileBrowerActionPage_Rename,
            ],
            @[
                ZZFileBrowerActionPage_Share,
            ],
        ];
    }
    ZZFileBrowerActionPage *actionPage = [[ZZFileBrowerActionPage alloc] initWithItem:item actionNames:dataSource sourceView:cell];
    actionPage.delegate = self;
    actionPage.modalPresentationStyle = UIModalPresentationPopover;
    actionPage.popoverPresentationController.delegate = self;
    actionPage.popoverPresentationController.sourceView = cell.imageView;
    actionPage.popoverPresentationController.sourceRect = cell.imageView.bounds;
    actionPage.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    if (@available(iOS 9.0, *)) {
        actionPage.popoverPresentationController.canOverlapSourceViewRect = NO;
    } else {
        // Fallback on earlier versions
    }
    [self presentViewController:actionPage animated:YES completion:nil];
}

/// MARK: -
/// MARK: select

- (void)didSelectItem:(ZZFileBrowerItem *)item {
    if (_delegate && [_delegate respondsToSelector:@selector(filePage:didSlectItem:)]) {
        [_delegate filePage:self didSlectItem:item];
    }
}

/// MARK: action

- (void)_paste {
    NSString *dealPath = [ZZFileBrowerManager manager].dealtPath;
    if (!dealPath) {
        return;
    }
    NSError *error;
    [ZZFileBrowerManager copyItemAtPath:dealPath toPath:_item.path error:&error];
    if (error) {
        NSLog(@"%@", error);
        [self alertWithTitle:@"粘贴失败" message:error.description];
        return;
    }
}

- (void)_reload {
    [self reloadAtDirectoryWithItem:_item];
    
}

- (void)_createDirectory {
    [self resignFirstResponder];
    NSString *dirName = [ZZFileBrowerManager duplicateNameWithOriginName:@"新建文件夹" amongItems:_item.children];
    if (!dirName) return;
    NSString *dirPath = [_item.path stringByAppendingPathComponent:dirName];
    NSError *error;
    [ZZFileBrowerManager createDirectoryAtPath:dirPath error:&error];
    if (error) {
        NSLog(@"%@", error);
        [self alertWithTitle:@"新建失败" message:error.description];
        return;
    }
    // 生成item
    ZZFileBrowerItem *newItem = [ZZFileBrowerManager createItemAtPath:dirPath error:&error];
    if (!newItem || error) {
        NSLog(@"%@", error);
        [self reloadAtDirectoryWithItem:_item];
        return;
    }
    // 修改当前item
    NSArray *oldChildrne = _item.children.copy;
    [_item.children addObject:newItem];
    // 根据当前排序刷新界面
    [_item sortChildrenWithType:_item.sortType];
    [self _reloadWithNewChildren:_item.children oldChildren:oldChildrne];
}

- (void)_showBrief {
    [self presentFileBriefWithItem:_item];
}

- (void)_deleteItem:(ZZFileBrowerItem *)item {
    NSError *error;
    [ZZFileBrowerManager removeItemAtPath:item.path error:&error];
    if (error) {
        NSLog(@"%@", error);
        [self alertWithTitle:@"删除失败" message:error.description];
        return;
    }
    NSUInteger idx = [_item.children indexOfObject:item];
    [_item.children removeObjectAtIndex:idx];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]];
    } completion:nil];
}

- (void)_renameItem:(ZZFileBrowerItem *)item {
    
}

/// MARK: selection

- (void)_selecting {
    _isSelecting = YES;
    [self setupNaviBarItem];
    [self _reload];
}

- (void)_selectDone {
    _isSelecting = NO;
    [self setupNaviBarItem];
    [self _reload];
}

- (void)_selectAll {
    [_item.children enumerateObjectsUsingBlock:^(ZZFileBrowerItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = YES;
    }];
    [self _reload];
}

- (void)_deselectAll {
    [_item.children enumerateObjectsUsingBlock:^(ZZFileBrowerItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    [self _reload];
}

/// MARK: sort

- (void)_reloadWithNewChildren:(NSArray<ZZFileBrowerItem *> *)newChildren oldChildren:(NSArray<ZZFileBrowerItem *> *)oldChildren {
    [self.collectionView performBatchUpdates:^{
        NSMutableArray<ZZFileBrowerItem *> *oldChildrenCopy = oldChildren.mutableCopy;
        NSMutableArray<NSIndexPath *> *insertIndexPaths = [NSMutableArray array];
        NSMutableArray<NSIndexPath *> *deleteIndexPaths = [NSMutableArray array];
        // 整理移动与插入项
        for (NSInteger toIdx = 0; toIdx < newChildren.count; toIdx++) {
            ZZFileBrowerItem *item = newChildren[toIdx];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toIdx inSection:0];
            NSUInteger fromIdx = [oldChildren indexOfObject:item];
            if (fromIdx == NSNotFound) {
                // 记录插入位置
                [insertIndexPaths addObject:toIndexPath];
            } else {
                // 剩下待删除位置
                [oldChildrenCopy removeObject:item];
                // 执行移动动画
                NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:fromIdx inSection:0];
                [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
            }
        }
        // 整理删除项
        // oldChildrenCopy 剩余待删除项
        for (NSInteger idx = 0; idx < oldChildrenCopy.count; idx++) {
            ZZFileBrowerItem *item = newChildren[idx];
            NSUInteger deleteIdx = [oldChildren indexOfObject:item];
            NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:deleteIdx inSection:0];
            [deleteIndexPaths addObject:deleteIndexPath];
        }
        // 执行插入动画
        if (insertIndexPaths.count) {
            [self.collectionView insertItemsAtIndexPaths:insertIndexPaths];
        }
        // 执行删除动画
        if (deleteIndexPaths.count) {
            [self.collectionView deleteItemsAtIndexPaths:deleteIndexPaths];
        }
    } completion:nil];
}

- (void)_sortByName {
    NSArray *oldChildrne = _item.children.copy;
    [_item sortChildrenWithType:ZZFileBrowerItemSortByName];
    [self _reloadWithNewChildren:_item.children oldChildren:oldChildrne];
}

- (void)_sortByDate {
    NSArray *oldChildrne = _item.children.copy;
    [_item sortChildrenWithType:ZZFileBrowerItemSortByDate];
    [self _reloadWithNewChildren:_item.children oldChildren:oldChildrne];
}

- (void)_sortBySize {
    NSArray *oldChildrne = _item.children.copy;
    [_item sortChildrenWithType:ZZFileBrowerItemSortBySize];
    [self _reloadWithNewChildren:_item.children oldChildren:oldChildrne];
}

- (void)_sortByType {
    NSArray *oldChildrne = _item.children.copy;
    [_item sortChildrenWithType:ZZFileBrowerItemSortByType];
    [self _reloadWithNewChildren:_item.children oldChildren:oldChildrne];
}

/// MARK: other action

/// 弹出简介
- (void)presentFileBriefWithItem:(ZZFileBrowerItem *)item {
    ZZFileBrowerBriefPage *briefPage = [[ZZFileBrowerBriefPage alloc] initWithItem:item];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:briefPage];
    __weak typeof(self) weakSelf = self;
    briefPage.openItem = ^(ZZFileBrowerBriefPage * _Nonnull briefPage, ZZFileBrowerItem * _Nonnull item) {
        [weakSelf didSelectItem:item];
    };
    [self presentViewController:navi animated:YES completion:nil];
}


/// MARK: - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _item.children.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZFileBrowerItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.item = self.item.children[indexPath.row];
    return cell;
}

/// MARK: - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZFileBrowerItem *item = self.item.children[indexPath.row];
    [self didSelectItem:item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;;
}

/// MARK: - <ZZFileBrowerItemCellDelegate>

/// 重命名完成确认
- (BOOL)cell:(ZZFileBrowerItemCell *)cell shouldEndRenamingWithName:(NSString *)name {
    NSError *error;
    [ZZFileBrowerManager renameItemAtPath:cell.item.path name:name error:&error];
    if (error) {
        [self alertWithTitle:@"重命名失败" message:error.description];
        return NO;
    }
    [self reloadAtDirectoryWithItem:_item];
    return YES;
}

- (void)cellDidLongPress:(ZZFileBrowerItemCell *)cell {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [generator prepare];
        [generator impactOccurred];
        //                UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc] init];
        //                [generator prepare];
        //                [generator selectionChanged];
    } else {
        // Fallback on earlier versions
    }
    [self presentFileActionWithItem:cell.item fromCell:cell];
}

/// MARK: - <ZZFileBrowerActionPageDelegate>

- (void)actionPage:(ZZFileBrowerActionPage *)actionPage didSelectAction:(NSString *)actionName {
    if (actionPage.item == _item) {
        /// 点击导航栏弹出菜单
        if ([ZZFileBrowerActionPage_Select isEqualToString:actionName]) {
            // 选择
            _isSelecting = !_isSelecting;
            
        } else if ([ZZFileBrowerActionPage_Mkdir isEqualToString:actionName]) {
            // 新建文件夹
            [self _createDirectory];
        } else if ([ZZFileBrowerActionPage_SortByName isEqualToString:actionName]) {
            // 名字排序
            [self _sortByName];
        } else if ([ZZFileBrowerActionPage_SortByDate isEqualToString:actionName]) {
            // 日期排序
            [self _sortByDate];
        } else if ([ZZFileBrowerActionPage_SortBySize isEqualToString:actionName]) {
            // 大小排序
            [self _sortBySize];
        } else if ([ZZFileBrowerActionPage_SortByType isEqualToString:actionName]) {
            // 类型排序
            [self _sortByType];
        }
    } else {
        /// 长按单元格弹出菜单
        ZZFileBrowerItem *item = actionPage.item;
        UIView *sourceView = actionPage.sourceView;
        if ([ZZFileBrowerActionPage_Copy isEqualToString:actionName]) {
            // 拷贝
            [ZZFileBrowerManager dealWithPath:item.path];
        } else if ([ZZFileBrowerActionPage_Duplicate isEqualToString:actionName]) {
            // 复制
            NSString *duplicateName = [ZZFileBrowerManager duplicateNameWithOriginName:item.name amongItems:_item.children];
            NSString *toPath = [[_item.path stringByDeletingLastPathComponent] stringByAppendingPathComponent:duplicateName];
            [ZZFileBrowerManager copyItemAtPath:item.path toPath:toPath error:nil];
        } else if ([ZZFileBrowerActionPage_Move isEqualToString:actionName]) {
            // 移动
            [ZZFileBrowerManager dealWithPath:item.path];
        } else if ([ZZFileBrowerActionPage_Delete isEqualToString:actionName]) {
            // 删除
            [self alertWithTitle:@"删除" message:@"您确定要删除该文件吗？" confirmAction:^{
                [self _deleteItem:item];
            }];
        } else if ([ZZFileBrowerActionPage_Rename isEqualToString:actionName]) {
            // 重命名
            ZZFileBrowerItemCell *cell = (ZZFileBrowerItemCell *)sourceView;
            [cell beginRenamingItem];
        } else if ([ZZFileBrowerActionPage_Brief isEqualToString:actionName]) {
            // 简介
            [self presentFileBriefWithItem:item];
        } else if ([ZZFileBrowerActionPage_Share isEqualToString:actionName]) {
            // 分享
            
        }
    }
}

///// MARK: - <UIViewControllerTransitioningDelegate>
//
///// present
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    if (_sourceViewInPresentation) {
//        return [[ZZFileBrowerAnimatedTransitioning alloc] initWithSourceView:_sourceViewInPresentation isPresented:YES];
//    }
//    return nil;
//}
//
///// dismiss
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    if ([dismissed isKindOfClass:[ZZFileBrowerActionPage class]]) {
//        UIView *sourceView = ((ZZFileBrowerActionPage *)dismissed).sourceView;
//        return [[ZZFileBrowerAnimatedTransitioning alloc] initWithSourceView:sourceView isPresented:NO];
//    }
//    return nil;
//}

///// push
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return [[ZZFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:YES];
//}
//
///// pop
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return [[ZZFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:YES];
//}

/// MARK: - <UIPopoverPresentationControllerDelegate>
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
//    if (operation == UINavigationControllerOperationPush) {
//        return [[ZZFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:YES];
//    } else if (operation == UINavigationControllerOperationPop){
//        return [[ZZFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:NO];
//    }
//    return [[ZZFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:NO];
//}

/// MARK: - getter

- (NSMutableArray<ZZFileBrowerItem *> *)pathNavigation {
    if (!_pathNavigation) {
        _pathNavigation = [NSMutableArray array];
    }
    return _pathNavigation;
}

- (UIView *)emptyView {
    if (_emptyView) {
        return _emptyView;
    }
    _emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
    _emptylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
    _emptylabel.text = @"文件夹为空";
    _emptylabel.font = [UIFont boldSystemFontOfSize:21.0f];
    _emptylabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    _emptylabel.textAlignment = NSTextAlignmentCenter;
    _emptyView.hidden = YES;
    [_emptyView addSubview:_emptylabel];
    return _emptyView;
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    CGFloat spacing = 16.0f;
    CGFloat column = 3;
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - spacing * (column + 1)) / column;
    itemWidth = (CGFloat)((int)itemWidth);
    itemWidth = itemWidth > 125.0f ? 125.0f : itemWidth;
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(itemWidth, itemWidth * 1.5);
    _layout.minimumLineSpacing = spacing;
    //_layout.minimumInteritemSpacing = spacing;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.sectionInset = UIEdgeInsetsMake(0, spacing, 0, spacing);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = NO;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.allowsSelection = YES;
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_collectionView registerClass:[ZZFileBrowerItemCell class] forCellWithReuseIdentifier:@"cell"];
    return _collectionView;
}

@end
