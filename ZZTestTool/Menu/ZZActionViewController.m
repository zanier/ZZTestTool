//
//  ZZActionViewController.m
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/6.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "ZZActionViewController.h"
#import "ZZAction.h"

@interface ZZActionViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger _rowCount;
    
}

@property (nonatomic, copy) NSArray<ZZAction *> *children;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZZActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// MARK: - getter

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
    _tableView.backgroundColor = UIColor.clearColor;
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
    return _children.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _children.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = UIColor.clearColor;
        cell.separatorInset = UIEdgeInsetsZero;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.accessoryView = imageView;
    }
//    NSString *text = _dataSource[indexPath.section][indexPath.row];
//    cell.textLabel.text = text;
//    if ([ZZFileBrowerActionPage_Delete isEqualToString:text]) {
//        cell.textLabel.textColor = UIColor.redColor;
//    } else {
//        cell.textLabel.textColor = UIColor.darkTextColor;
//    }
//    UIImageView *imageView = (UIImageView *)cell.accessoryView;
//    NSInteger idx = [_sortTextDictionary.allValues indexOfObject:text];
//    if (idx != NSNotFound) {
//        ZZFileBrowerItemSortType sortType = [_sortTextDictionary.allKeys[idx] integerValue];
//        if (sortType == _item.sortType) {
//            imageView.image = [NSBundle hs_imageNamed:@"icon_action_selected@2x" type:@"png" inDirectory:@"ActionIcon"];
//        } else {
//            imageView.image = nil;
//        }
//    } else {
//        imageView.image = [ZZFileBrowerManager imageWithActionText:text];
//    }
    return cell;
}

@end
