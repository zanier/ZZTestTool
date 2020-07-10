//
//  HsFileBrowerActionPage.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/30.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsFileBrowerActionPage.h"
#import "HsFileBrowerItem.h"
#import "HsFileBrowerManager.h"
#import <AudioToolBox/AudioServices.h>
#import "HsFileBrowerManager.h"

@interface HsFileBrowerActionPage () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger _rowCount;
}

@property (nonatomic, strong) HsFileBrowerItem *item;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *dataSource;

//@property (nonatomic, weak, readwrite) UIView *sourceView;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HsFileBrowerActionPage

/// MARK: - init

+ (id)createPage:(NSDictionary *)params {
    HsFileBrowerActionPage *page = [[HsFileBrowerActionPage alloc] init];
    return page;
}

- (instancetype)initWithItem:(HsFileBrowerItem *)item actionNames:(NSArray<NSArray<NSString *> *> *)actionNames sourceView:(UIView *)sourceView {
    if (self = [super init]) {
        _item = item;
        _dataSource = actionNames.copy;
        _sourceView = sourceView;
    }
    return self;
}

/// MARK: life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
//    if (_item.isDir) {
//        self.imageView.image = [UIImage imageNamed:@"file_dir"];
//    } else {
//        self.imageView.image = [UIImage imageNamed:[HsFileBrowerUtil imageNameWithType:_item.typeString]];
//    }
//
//    [self.view addSubview:self.blurEffectView];
    
    [self setupItem];
    CGFloat tableWidth = 240.0f;
    CGFloat headerHeight = [self tableView:self.tableView heightForHeaderInSection:1];
//    headerHeight = 0;
    CGFloat tableHeight = _rowCount * self.tableView.rowHeight + (_dataSource.count - 1) * headerHeight;
    //self.tableView.frame = CGRectMake(0, 0, tableWidth, tableHeight);
    self.preferredContentSize = CGSizeMake(tableWidth, tableHeight);
//    [self.view addSubview:self.imageView];
    [self.view addSubview:self.tableView];
//    [self.tableView reloadData];
}

//- (CGSize)preferredContentSize {
////    return self.tableView.bounds.size;
//    CGFloat tableWidth = 240.0f;
//    CGFloat headerHeight = [self tableView:_tableView heightForHeaderInSection:1];
//    CGFloat tableHeight = _rowCount * _tableView.rowHeight + (_dataSource.count - 1) * headerHeight;
//
//    return CGSizeMake(tableWidth, tableHeight);
//}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    return;
    self.tableView.frame = self.view.bounds;
    return;
    CGFloat perH = UIScreen.mainScreen.bounds.size.width / 3;
    CGFloat perV = UIScreen.mainScreen.bounds.size.height / 2;
    NSInteger locH = 0, locV = 0;
    if (_sourceView) {
        locH = (CGRectGetMidX(_sourceView.frame) / perH);
        locV = (CGRectGetMidY(_sourceView.frame) / perV);
    }
    
    CGFloat imageTop;
    CGFloat imageWidth = 65.0f;
    if (locV <= 0) imageTop = 100.0f;
    else imageTop = CGRectGetHeight(self.view.frame) - 88 - imageWidth;
    CGFloat imageLeft = perH * (locH + 0.5) - imageWidth / 2;
    _imageView.frame = CGRectMake(imageLeft, imageTop, imageWidth, imageWidth);
    
    CGFloat tableWidth = 240.0f;
    CGFloat headerHeight = [self tableView:_tableView heightForHeaderInSection:1];
    CGFloat tableHeight = _rowCount * _tableView.rowHeight + (_dataSource.count - 1) * headerHeight;
    
    CGFloat left = perH * (locH + 0.5) - tableWidth / 2;
    CGFloat minLeft = 32;
    CGFloat maxLeft = CGRectGetWidth(self.view.bounds) - minLeft - tableWidth;
    if (left < minLeft) left = minLeft;
    if (left > maxLeft) left = maxLeft;
    CGFloat top;
    if (locV <= 0) top = CGRectGetMaxY(_imageView.frame) + 20;
    else top = CGRectGetMinY(_imageView.frame) - 20 - tableHeight;

    _tableView.frame = CGRectMake(left, top, tableWidth, tableHeight);
}

- (void)setupItem {
    _rowCount = 0;
    for (NSArray *array in _dataSource) {
        _rowCount += array.count;
    }
    [self.tableView reloadData];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// MARK: -

- (UIVisualEffectView *)blurEffectView {
    if (_blurEffectView) {
        return _blurEffectView;
    }
    _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _blurEffectView.frame = UIScreen.mainScreen.bounds;
    return _blurEffectView;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    return _imageView;
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.bounces = NO;
    _tableView.rowHeight = 45.0f;
    _tableView.scrollEnabled = NO;
    //_tableView.layer.cornerRadius = 10.0f;
    //_tableView.layer.masksToBounds = YES;
    return _tableView;
}

/// MARK: - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
        cell.backgroundColor = UIColor.whiteColor;
        cell.separatorInset = UIEdgeInsetsZero;
    }
    NSString *text = _dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = text;
    if ([HsFileBrowerActionPage_Delete isEqualToString:text]) {
        cell.textLabel.textColor = UIColor.redColor;
    } else {
        cell.textLabel.textColor = UIColor.darkTextColor;
    }
    return cell;
}

/// MARK: - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 8.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playSoundPop];
    return indexPath;
}

- (void)playSoundPop {
    AudioServicesPlaySystemSound(1520);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *title = self.dataSource[indexPath.section][indexPath.row];
        if ([self.delegate respondsToSelector:@selector(actionPage:didSelectAction:)]) {
            [self.delegate actionPage:self didSelectAction:title];
        }
    }];
}

@end

/*
 
 @property (nonatomic, strong) NSArray<NSArray<NSString *> *> *actionDataSource;
 @property (nonatomic, strong) UIVisualEffectView *blurEffectView;
 @property (nonatomic, strong) UIImageView *imageView;
 @property (nonatomic, strong) UITableView *tableView;


 - (void)playSoundPop {
     AudioServicesPlaySystemSound(1520);
 }

 //- (void)presentActionWithItem:(HsFileBrowerItem *)item {
 - (void)presentActionAtIndexPath:(NSIndexPath *)indexPath {
     HsFileBrowerItem *_currentItem = self.dataSource[indexPath.row];
     _indexPathInEditing = indexPath;
     
     
     if (!self.blurEffectView.superview) {
         self.blurEffectView.alpha = 0.0f;
         [self.view addSubview:self.blurEffectView];
         [self.view addSubview:self.imageView];
         [self.view addSubview:self.tableView];
     }
     self.blurEffectView.hidden = NO;
     self.imageView.hidden = NO;
     self.tableView.hidden = NO;
     if (!_currentItem.isDir) {
         self.actionDataSource = @[
             @[
                 HsFileBrowerActionPage_Copy,
             ],
         ];
     } else {
         self.actionDataSource = @[
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
     _actionRowCount = 0;
     for (NSArray *array in self.actionDataSource) {
         _actionRowCount += array.count;
     }
     [self.tableView reloadData];
     
     HsFileBrowerItemCell *sourceCell = (HsFileBrowerItemCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
     [self layoutActionViewsWithSourceView:sourceCell];
     CGRect newFrame = self.imageView.frame;
     
     self.imageView.image = sourceCell.imageView.image;
     self.imageView.frame = [sourceCell.imageView convertRect:sourceCell.imageView.bounds toView:self.view];
     //self.tableView.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 0, 0);
     sourceCell.imageView.hidden = YES;

     
     self.tableView.transform = CGAffineTransformMakeScale(0, 0);
     [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
         self.blurEffectView.alpha = 1.0f;
         self.imageView.frame = newFrame;
         self.tableView.transform = CGAffineTransformIdentity;
     } completion:^(BOOL finished) {
         if (finished) {
             
         }
     }];
 }

 - (void)hideActionViews {
     
     HsFileBrowerItemCell *cell = (HsFileBrowerItemCell *)[self.collectionView cellForItemAtIndexPath:_indexPathInEditing];
     CGRect newFrame = [cell.imageView convertRect:cell.imageView.bounds toView:self.view];
     [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
         self.imageView.frame = newFrame;
         self.tableView.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 0, 0);
         self.blurEffectView.alpha = 0.0f;
     } completion:^(BOOL finished) {
         if (finished) {
             cell.imageView.hidden = NO;
             self->_indexPathInEditing = nil;
             self.blurEffectView.hidden = YES;
             self.tableView.hidden = YES;
             self.imageView.hidden = YES;
         }
     }];
 //    [UIView animateWithDuration:0.2f animations:^{
 //        self.imageView.frame = newFrame;
 //        self.tableView.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 0, 0);
 //        self.blurEffectView.alpha = 0.0f;
 //    } completion:^(BOOL finished) {
 //        if (finished) {
 //            cell.imageView.hidden = NO;
 //            self->_indexPathInEditing = nil;
 //            self.blurEffectView.hidden = YES;
 //            self.tableView.hidden = YES;
 //            self.imageView.hidden = YES;
 //        }
 //    }];

 }

 /// MARK: - <UITableViewDataSource>

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.actionDataSource.count;
 }

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return [self.actionDataSource[section] count];
 }

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     if (!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
         cell.backgroundColor = UIColor.clearColor;
         cell.separatorInset = UIEdgeInsetsZero;
     }
     NSString *text = self.actionDataSource[indexPath.section][indexPath.row];
     cell.textLabel.text = text;
     if ([HsFileBrowerActionPage_Delete isEqualToString:text]) {
         cell.textLabel.textColor = UIColor.redColor;
     } else {
         cell.textLabel.textColor = UIColor.darkTextColor;
     }
     return cell;
 }

 /// MARK: - <UITableViewDelegate>

 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     if (section == 0) {
         return 0;
     } else {
         return 8;
     }
 }

 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
     return 0.01;
 }

 - (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self playSoundPop];
     return indexPath;
 }


 */
