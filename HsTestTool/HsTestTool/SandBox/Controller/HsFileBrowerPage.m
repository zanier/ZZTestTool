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

@interface HsFileBrowerPage () <HsFileBrowerScrollHeaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate, HsFileBrowerItemCellDelegate, HsFileBrowerActionPageDelegate, UINavigationControllerDelegate> {
    
    UIView *_sourceViewInPresentation;
    NSIndexPath *_indexPathInEditing;
    NSInteger _actionRowCount;
    __weak HsFileBrowerItem *_currentItem;
}

@property (nonatomic, strong) NSMutableArray<HsFileBrowerItem *> *dataSource;
@property (nonatomic, strong) NSMutableArray<HsFileBrowerItem *> *pathNavigation;

@property (nonatomic, strong) UIToolbar *headerToolBar; //
@property (nonatomic, strong) HsFileBrowerScrollHeader *scrollHeader; // 顶部滑动式图
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation HsFileBrowerPage

/// MARK: - init

+ (id)createPage:(NSDictionary *)params {
    HsFileBrowerPage *page = [[HsFileBrowerPage alloc] init];
    return page;
}

- (instancetype)initWithItem:(HsFileBrowerItem *)item delegate:(id <HsFileBrowerPageDelegate>)delegate {
    if (self = [super init]) {
        _currentItem = item;
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithItem:(HsFileBrowerItem *)item {
    if (self = [super init]) {
        _currentItem = item;
    }
    return self;
}

/// MARK: - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件";
    self.view.backgroundColor = UIColor.whiteColor;
    self.emptyView.hidden = YES;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.emptyView];

    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.view addGestureRecognizer:longPress];
}

///// 刷新显示指定文件夹下的文件，返回是否刷新
///// @param path 文件夹路径
//- (BOOL)loadWithPath:(NSString *)path {
//    if ([_currentItem.path isEqualToString:path]) {
//        return NO;
//    }
//    NSError *error = nil;
//    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
//    if (error) {
//        return NO;
//    }
//    HsFileBrowerItem *rootItem = [[HsFileBrowerItem alloc] initWithPath:path name:path.lastPathComponent attributes:attributes parent:nil];
//    return [self enterDirectoryWithItem:rootItem];
//}
//
///// 进入文件夹
///// 根据记录自动pop或push，在进入下级或返回上级都可以使用
///// @param item 文件夹数据
//- (BOOL)enterDirectoryWithItem:(HsFileBrowerItem *)item {
//    BOOL didReload = [self reloadAtDirectoryWithItem:item];
//    if (!didReload) {
//        // 路径不正确，不能刷新
//        return NO;
//    }
//    _currentItem = item;
//    if ([self.pathNavigation containsObject:item]) {
//        // 返回到上级的目录
//        NSInteger idx = [self.pathNavigation indexOfObject:item];
//        if (idx >= self.pathNavigation.count - 1) {
//            return NO;
//        }
//        // 移除目录后面的路径
//        [self.pathNavigation removeObjectsInRange:NSMakeRange(idx + 1, self.pathNavigation.count - idx - 1)];
//        // 头部移动到当前目录，
//        [self.scrollHeader popToIndex:idx];
//    } else {
//        // 进入下级目录
//        [self.pathNavigation addObject:item];
//        // 移动到当前目录
//        [self.scrollHeader push:item.name];
//    }
//    return didReload;
//}

- (void)setItem:(HsFileBrowerItem *)item {
    if (_item == item) {
        return;
    }
    _item = item;
    [self reloadAtDirectoryWithItem:_item];
}

/// 刷新显示指定文件夹下的文件，返回是否刷新
/// @param item 文件夹数据
- (BOOL)reloadAtDirectoryWithItem:(HsFileBrowerItem *)item {
    _item = item;
    NSString *path = item.path;
    BOOL isDir = NO;
    // 路径不存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) return NO;
    // 非文件夹
    if (!isDir) return NO;
    _item.children = [HsFileBrowerManager contentItemsOfItem:_item];
    _dataSource = _item.children.mutableCopy;
    // 刷新
    [self.collectionView reloadData];
    self.emptyView.hidden = (self.dataSource.count != 0);
    return YES;
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
    UIMenuItem *pasteItem = [[UIMenuItem alloc] initWithTitle:@"粘贴" action:@selector(_paste:)];
    UIMenuItem *createDirItem = [[UIMenuItem alloc] initWithTitle:@"新建文件夹" action:@selector(_createDirectory:)];
    UIMenuItem *selectAllItem = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(_selectAll:)];
    UIMenuItem *briefItem = [[UIMenuItem alloc] initWithTitle:@"简介" action:@selector(_showBrief:)];
    UIMenuItem *reloadItem = [[UIMenuItem alloc] initWithTitle:@"刷新" action:@selector(_reload:)];

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

- (void)_reload:(UIMenuController *)menu {
    NSLog(@"reload ：\n%@", _dataSource);
    [self.collectionView reloadData];
}

- (NSString *)newDirectoryName {
    NSString *dirName;
    for (int i = 0; i < INT32_MAX; i++) {
        dirName = @"新建文件夹";
        if (i > 0) {
            dirName = [dirName stringByAppendingFormat:@" %d", i];
        }
        BOOL exist = NO;
        for (HsFileBrowerItem *child in _item.children) {
            if ([dirName isEqualToString:child.name]) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            return dirName;
        }
    }
    return dirName;
}

- (void)_createDirectory:(UIMenuController *)menu {
    NSString *dirName = [self newDirectoryName];
    NSString *dirPath = [_item.path stringByAppendingPathComponent:dirName];
    NSError *error;
    [HsFileBrowerManager createDirectoryAtPath:dirPath error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        [self reloadAtDirectoryWithItem:_item];
    }
}

- (void)_showBrief:(UIMenuController *)menu {
    [self presentFileBriefWithItem:_currentItem];
}

/// MARK: - getter

- (NSMutableArray<HsFileBrowerItem *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
    label.center = _emptyView.center;
    label.text = @"文件夹为空";
    label.font = [UIFont boldSystemFontOfSize:21.0f];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_emptyView addSubview:label];
    return _emptyView;
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width / 3;
    itemWidth = (CGFloat)((int)itemWidth) - 0;
    itemWidth = itemWidth > 125.0f ? 125.0f : itemWidth;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemWidth * 1.3);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat scrollBottom = HsFileBrower_NavBarBottom + [HsFileBrowerScrollHeader defaultHeight];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, scrollBottom, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - scrollBottom) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = NO;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_collectionView registerClass:[HsFileBrowerItemCell class] forCellWithReuseIdentifier:@"cell"];
    return _collectionView;
}

/// MARK: - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HsFileBrowerItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.item = self.dataSource[indexPath.row];
    return cell;
}

/// MARK: - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HsFileBrowerItem *item = self.dataSource[indexPath.row];
    [self didSelectItem:item];
}

/// MARK: - <HsFileBrowerItemCellDelegate>

- (BOOL)cell:(HsFileBrowerItemCell *)cell shouldEndRenamingWithName:(NSString *)name {
    if (!name || name.length == 0) {
        NSLog(@"Invalid name");
        return NO;
    }
    return YES;
}

- (void)cellDidLongPressed:(HsFileBrowerItemCell *)cell {
    [self presentFileActionWithItem:cell.item sourceView:cell.imageView];
}

/// MARK: - selection

- (void)didSelectItem:(HsFileBrowerItem *)item {
    if (_delegate && [_delegate respondsToSelector:@selector(filePage:didSlectItem:)]) {
        [_delegate filePage:self didSlectItem:item];
    }
}

/// MARK: - item long press action

- (void)presentFileActionWithItem:(HsFileBrowerItem *)item sourceView:(UIView *)sourceView {
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
                HsFileBrowerActionPage_Paste,
                HsFileBrowerActionPage_Copy,
                HsFileBrowerActionPage_Move,
                HsFileBrowerActionPage_Delete,
            ],
            @[
                HsFileBrowerActionPage_Brief,
            ],
            @[
                HsFileBrowerActionPage_Share,
            ],
        ];
    }

    HsFileBrowerActionPage *testVC = [[HsFileBrowerActionPage alloc] initWithItem:item actionNames:dataSource sourceView:sourceView];
    testVC.delegate = self;
    //testVC.preferredContentSize = testVC.preferredContentSize;
    testVC.modalPresentationStyle = UIModalPresentationPopover;
    testVC.popoverPresentationController.delegate = self;
    testVC.popoverPresentationController.sourceView = sourceView;
    testVC.popoverPresentationController.sourceRect = CGRectNull;
    testVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //testVC.popoverPresentationController.backgroundColor = [UIColor clearColor];
    testVC.popoverPresentationController.canOverlapSourceViewRect = NO;
    [self presentViewController:testVC animated:YES completion:nil];
}

/// MARK: <HsFileBrowerActionPageDelegate>

- (void)actionPage:(HsFileBrowerActionPage *)actionPage didSelectAction:(NSString *)actionName {
    HsFileBrowerItem *item = actionPage.item;
    UIView *sourceView = actionPage.sourceView;
    if ([HsFileBrowerActionPage_Copy isEqualToString:actionName]) {
        [HsFileBrowerManager dealWithPath:item.path];
    } else if ([HsFileBrowerActionPage_Paste isEqualToString:actionName]) {
        return;
    } else if ([HsFileBrowerActionPage_Move isEqualToString:actionName]) {
        [HsFileBrowerManager dealWithPath:item.path];
    } else if ([HsFileBrowerActionPage_Delete isEqualToString:actionName]) {
        [HsFileBrowerManager removeItemAtPath:item.path error:nil];
    } else if ([HsFileBrowerActionPage_Rename isEqualToString:actionName]) {
        HsFileBrowerItemCell *cell = (HsFileBrowerItemCell *)sourceView;
        [cell beginRenamingItem];
    } else if ([HsFileBrowerActionPage_Brief isEqualToString:actionName]) {
        [self presentFileBriefWithItem:item];
    } else if ([HsFileBrowerActionPage_Share isEqualToString:actionName]) {
        
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

/// MARK: - <UIViewControllerTransitioningDelegate>

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
//        return [[HsFileBrowerAnimatedTransitioning alloc] initWithSourceView:sourceView isPresented:YES];
//    }
//    return nil;
//}
//
///// push
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:YES];
//}
//
///// pop
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:YES];
//}

///// MARK: - <UIPopoverPresentationControllerDelegate>
//- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
//    return UIModalPresentationNone;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
//    if (operation == UINavigationControllerOperationPush) {
//        return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:YES];
//    } else if (operation == UINavigationControllerOperationPop){
//        return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:NO];
//    }
//    return [[HsFileBrowerNavigateTransitioning alloc] initWithSourceView:self.headerToolBar isPresented:NO];
//}


@end
