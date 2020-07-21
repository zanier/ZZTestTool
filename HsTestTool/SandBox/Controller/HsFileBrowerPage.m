//
//  HsFileBrowerPageViewController.m
//  HsBusinessEngine
//
//  Created by ZZ on 2020/6/4.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsFileBrowerPage.h"
#import "HsTestToolDefine.h"
#import "HsFileBrowerManager.h"
#import "HsFileBrowerScrollHeader.h"
#import "HsFileBrowerItem.h"
#import "HsFileBrowerItemCell.h"
#import "HsFileBrowerActionPage.h"
#import "HsFileBrowerBriefPage.h"
#import "HsFileBrowerAnimatedTransitioning.h"
#import "HsFileBrowerNavigateTransitioning.h"
#import <AudioToolBox/AudioServices.h>

@interface HsFileBrowerPage () <UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate, HsFileBrowerItemCellDelegate, HsFileBrowerActionPageDelegate, UINavigationControllerDelegate> {
    BOOL _isSelecting;
    UICollectionViewFlowLayout *_layout;
}

@property (nonatomic, strong) NSMutableArray<HsFileBrowerItem *> *pathNavigation;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UILabel *emptylabel;

@end

@implementation HsFileBrowerPage

/// MARK: - init

- (instancetype)initWithItem:(HsFileBrowerItem *)item delegate:(id <HsFileBrowerPageDelegate>)delegate {
    if (self = [super init]) {
        _item = item;
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithItem:(HsFileBrowerItem *)item {
    if (self = [super init]) {
        _item = item;
    }
    return self;
}

/// MARK: - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNaviBarItem];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.view addGestureRecognizer:longPress];
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
    CGFloat scrollBottom = HsFileBrower_NavBarBottom + [HsFileBrowerScrollHeader defaultHeight];
    scrollBottom -= topPoint.y;
    self.collectionView.frame = CGRectMake(0, scrollBottom, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - scrollBottom);
    _emptyView.frame = self.collectionView.bounds;
    _emptylabel.center = _emptyView.center;
}

- (void)setItem:(HsFileBrowerItem *)item {
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
- (void)reloadAtDirectoryWithItem:(HsFileBrowerItem *)item {
    _item = item;
    [self setTitle:_item.name];
    NSString *path = item.path;
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        if (!isDir) return;
        _item.children = [HsFileBrowerManager contentItemsOfItem:_item].mutableCopy;
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

/// MARK: view long press action

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [longPress locationInView:self.view];
        [self showMenuControllerAtPoint:location];
    }
}

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

/// MARK: - action

- (void)_paste {
    NSString *dealPath = [HsFileBrowerManager manager].dealtPath;
    if (!dealPath) {
        return;
    }
    NSError *error;
    [HsFileBrowerManager copyItemAtPath:dealPath toPath:_item.path error:&error];
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
    NSString *dirName = [HsFileBrowerManager duplicateNameWithOriginName:@"新建文件夹" amongItems:_item.children];
    if (!dirName) return;
    NSString *dirPath = [_item.path stringByAppendingPathComponent:dirName];
    NSError *error;
    [HsFileBrowerManager createDirectoryAtPath:dirPath error:&error];
    if (error) {
        NSLog(@"%@", error);
        [self alertWithTitle:@"新建失败" message:error.description];
    } else {
        [self reloadAtDirectoryWithItem:_item];
    }
}

- (void)_showBrief {
    [self presentFileBriefWithItem:_item];
}

- (void)_deleteItem:(HsFileBrowerItem *)item {
    NSError *error;
    [HsFileBrowerManager removeItemAtPath:item.path error:&error];
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

- (void)_renameItem:(HsFileBrowerItem *)item {
    
}

/// MARK: select

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
    [_item.children enumerateObjectsUsingBlock:^(HsFileBrowerItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = YES;
    }];
    [self _reload];
}

- (void)_deselectAll {
    [_item.children enumerateObjectsUsingBlock:^(HsFileBrowerItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    [self _reload];
}

/// MARK: sort

- (void)_reloadWithNewChildren:(NSArray<HsFileBrowerItem *> *)newChildren oldChildren:(NSArray<HsFileBrowerItem *> *)oldChildren {
    [self.collectionView performBatchUpdates:^{
        for (NSUInteger toIdx = 0; toIdx < newChildren.count; toIdx++) {
            HsFileBrowerItem *item = newChildren[toIdx];
            NSUInteger fromIdx = [oldChildren indexOfObject:item];
            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:fromIdx inSection:0];
            NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:toIdx inSection:0];
            [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        }
    } completion:nil];
}

- (void)_sortByName {
    NSArray *oldChildrne = _item.children.copy;
    [_item sortChildrenWithType:HsFileBrowerItemSortByName];
    [self _reloadWithNewChildren:_item.children oldChildren:oldChildrne];
}

- (void)_sortByDate {
    NSArray *oldChildrne = _item.children.copy;
    [_item sortChildrenWithType:HsFileBrowerItemSortByDate];
    [self _reloadWithNewChildren:_item.children oldChildren:oldChildrne];
}

- (void)_sortBySize {
    NSArray *oldChildrne = _item.children.copy;
    [_item sortChildrenWithType:HsFileBrowerItemSortBySize];
    [self _reloadWithNewChildren:_item.children oldChildren:oldChildrne];
}

- (void)_sortByType {
    NSArray *oldChildrne = _item.children.copy;
    [_item sortChildrenWithType:HsFileBrowerItemSortByType];
    [self _reloadWithNewChildren:_item.children oldChildren:oldChildrne];
}

/// MARK: - getter

- (NSMutableArray<HsFileBrowerItem *> *)pathNavigation {
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
    CGFloat margin = 16.0f;
    CGFloat column = 3;
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - margin * (column + 1)) / column;
    itemWidth = (CGFloat)((int)itemWidth);
    itemWidth = itemWidth > 125.0f ? 125.0f : itemWidth;
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(itemWidth, itemWidth * 1.5);
    _layout.minimumLineSpacing = margin;
    //_layout.minimumInteritemSpacing = margin;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = NO;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_collectionView registerClass:[HsFileBrowerItemCell class] forCellWithReuseIdentifier:@"cell"];
    return _collectionView;
}

/// MARK: - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _item.children.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HsFileBrowerItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.item = self.item.children[indexPath.row];
    return cell;
}

/// MARK: - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HsFileBrowerItem *item = self.item.children[indexPath.row];
    [self didSelectItem:item];
}

/// MARK: - <HsFileBrowerItemCellDelegate>

- (BOOL)cell:(HsFileBrowerItemCell *)cell shouldEndRenamingWithName:(NSString *)name {
    NSError *error;
    [HsFileBrowerManager renameItemAtPath:cell.item.path name:name error:&error];
    if (error) {
        [self alertWithTitle:@"重命名失败" message:error.description];
        return NO;
    }
    [self reloadAtDirectoryWithItem:_item];
    return YES;
}

- (void)cellDidLongPressed:(HsFileBrowerItemCell *)cell {
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

/// MARK: - selection

- (void)didSelectItem:(HsFileBrowerItem *)item {
    if (_delegate && [_delegate respondsToSelector:@selector(filePage:didSlectItem:)]) {
        [_delegate filePage:self didSlectItem:item];
    }
}

/// MARK: - right barbutton action

- (void)presentPopoverWithRightButton:(UIButton *)button {
    NSArray *dataSource = @[
        @[
            HsFileBrowerActionPage_Select,
            HsFileBrowerActionPage_Mkdir,
        ],
        @[
            HsFileBrowerActionPage_SortByName,
            HsFileBrowerActionPage_SortByDate,
            HsFileBrowerActionPage_SortBySize,
            HsFileBrowerActionPage_SortByType,
        ],
    ];
    HsFileBrowerActionPage *actionPage = [[HsFileBrowerActionPage alloc] initWithItem:_item actionNames:dataSource sourceView:button];
    actionPage.delegate = self;
    actionPage.modalPresentationStyle = UIModalPresentationPopover;
    actionPage.popoverPresentationController.delegate = self;
    actionPage.popoverPresentationController.sourceView = button;
    actionPage.popoverPresentationController.sourceRect = button.bounds;
    actionPage.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    actionPage.popoverPresentationController.canOverlapSourceViewRect = NO;
    [self presentViewController:actionPage animated:YES completion:nil];
}

/// MARK: - item long press action

- (void)presentFileActionWithItem:(HsFileBrowerItem *)item fromCell:(HsFileBrowerItemCell *)cell {
    NSArray *dataSource;
    if (!item.isDir) {
        dataSource = @[
            @[
                HsFileBrowerActionPage_Copy,
            ],
        ];
    } else {
        dataSource = @[
            @[
                HsFileBrowerActionPage_Copy,
                HsFileBrowerActionPage_Duplicate,
                HsFileBrowerActionPage_Move,
                HsFileBrowerActionPage_Delete,
            ],
            @[
                HsFileBrowerActionPage_Brief,
                HsFileBrowerActionPage_Rename,
            ],
            @[
                HsFileBrowerActionPage_Share,
            ],
        ];
    }
    HsFileBrowerActionPage *actionPage = [[HsFileBrowerActionPage alloc] initWithItem:item actionNames:dataSource sourceView:cell];
    actionPage.delegate = self;
    actionPage.modalPresentationStyle = UIModalPresentationPopover;
    actionPage.popoverPresentationController.delegate = self;
    actionPage.popoverPresentationController.sourceView = cell.imageView;
    actionPage.popoverPresentationController.sourceRect = cell.imageView.bounds;
    actionPage.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    actionPage.popoverPresentationController.canOverlapSourceViewRect = NO;
    [self presentViewController:actionPage animated:YES completion:nil];
}

/// MARK: <HsFileBrowerActionPageDelegate>

- (void)actionPage:(HsFileBrowerActionPage *)actionPage didSelectAction:(NSString *)actionName {
    if (actionPage.item == _item) {
        /// 点击导航栏弹出菜单
        if ([HsFileBrowerActionPage_Select isEqualToString:actionName]) {
            // 选择
            _isSelecting = !_isSelecting;
            
        } else if ([HsFileBrowerActionPage_Mkdir isEqualToString:actionName]) {
            // 新建文件夹
            [self _createDirectory];
        } else if ([HsFileBrowerActionPage_SortByName isEqualToString:actionName]) {
            // 名字排序
            [self _sortByName];
        } else if ([HsFileBrowerActionPage_SortByDate isEqualToString:actionName]) {
            // 日期排序
            [self _sortByDate];
        } else if ([HsFileBrowerActionPage_SortBySize isEqualToString:actionName]) {
            // 大小排序
            [self _sortBySize];
        } else if ([HsFileBrowerActionPage_SortByType isEqualToString:actionName]) {
            // 类型排序
            [self _sortByType];
        }
    } else {
        /// 长按单元格弹出菜单
        HsFileBrowerItem *item = actionPage.item;
        UIView *sourceView = actionPage.sourceView;
        if ([HsFileBrowerActionPage_Copy isEqualToString:actionName]) {
            // 拷贝
            [HsFileBrowerManager dealWithPath:item.path];
        } else if ([HsFileBrowerActionPage_Duplicate isEqualToString:actionName]) {
            // 复制
            NSString *duplicateName = [HsFileBrowerManager duplicateNameWithOriginName:item.name amongItems:_item.children];
            NSString *toPath = [[_item.path stringByDeletingLastPathComponent] stringByAppendingPathComponent:duplicateName];
            [HsFileBrowerManager copyItemAtPath:item.path toPath:toPath error:nil];
        } else if ([HsFileBrowerActionPage_Move isEqualToString:actionName]) {
            // 移动
            [HsFileBrowerManager dealWithPath:item.path];
        } else if ([HsFileBrowerActionPage_Delete isEqualToString:actionName]) {
            // 删除
            [self _deleteItem:item];
        } else if ([HsFileBrowerActionPage_Rename isEqualToString:actionName]) {
            // 重命名
            HsFileBrowerItemCell *cell = (HsFileBrowerItemCell *)sourceView;
            [cell beginRenamingItem];
        } else if ([HsFileBrowerActionPage_Brief isEqualToString:actionName]) {
            // 简介
            [self presentFileBriefWithItem:item];
        } else if ([HsFileBrowerActionPage_Share isEqualToString:actionName]) {
            // 分享
            
        }
    }
}

- (void)presentFileBriefWithItem:(HsFileBrowerItem *)item {
    HsFileBrowerBriefPage *briefPage = [[HsFileBrowerBriefPage alloc] initWithItem:item];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:briefPage];
    __weak typeof(self) weakSelf = self;
    briefPage.openItem = ^(HsFileBrowerBriefPage * _Nonnull briefPage, HsFileBrowerItem * _Nonnull item) {
        [weakSelf didSelectItem:item];
    };
    [self presentViewController:navi animated:YES completion:nil];
}

///// MARK: - <UIViewControllerTransitioningDelegate>
//
///// present
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    if (_sourceViewInPresentation) {
//        return [[HsFileBrowerAnimatedTransitioning alloc] initWithSourceView:_sourceViewInPresentation isPresented:YES];
//    }
//    return nil;
//}
//
///// dismiss
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    if ([dismissed isKindOfClass:[HsFileBrowerActionPage class]]) {
//        UIView *sourceView = ((HsFileBrowerActionPage *)dismissed).sourceView;
//        return [[HsFileBrowerAnimatedTransitioning alloc] initWithSourceView:sourceView isPresented:NO];
//    }
//    return nil;
//}

///// push
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:YES];
//}
//
///// pop
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:YES];
//}

/// MARK: - <UIPopoverPresentationControllerDelegate>
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
//    if (operation == UINavigationControllerOperationPush) {
//        return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:YES];
//    } else if (operation == UINavigationControllerOperationPop){
//        return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:NO];
//    }
//    return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:NO];
//}


@end
