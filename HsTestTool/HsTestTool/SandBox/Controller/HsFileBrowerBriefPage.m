//
//  HsFileBrowerBriefPage.m
//  HsBusinessEngine
//
//  Created by handsome on 2020/6/30.
//  Copyright © 2020 tzyj. All rights reserved.
//

#import "HsFileBrowerBriefPage.h"
#import "HsTestToolDefine.h"
#import "HsFileBrowerManager.h"
#import "HsFileBrowerItem.h"

@interface HsFileBrowerBriefPage () <UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *_indexPathUnderLongPressed;
}

@property (nonatomic, strong) HsFileBrowerItem *item;
@property (nonatomic, strong) NSArray<NSString *> *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *headerNameLabel;
@property (nonatomic, strong) UILabel *headerTypeLabel;
@property (nonatomic, strong) UIButton *headerOpenButton;

@end

@implementation HsFileBrowerBriefPage

/// MARK: - init

+ (id)createPage:(NSDictionary *)params {
    HsFileBrowerBriefPage *page = [[HsFileBrowerBriefPage alloc] init];
    return page;
}

- (instancetype)initWithItem:(HsFileBrowerItem *)item {
    if (self = [super init]) {
        _item = item;
    }
    return self;
}

static NSString *const HsFileBrowerBriefCell_Type = @"种类";
static NSString *const HsFileBrowerBriefCell_Size = @"大小";
static NSString *const HsFileBrowerBriefCell_CreateDate = @"创建时间";
static NSString *const HsFileBrowerBriefCell_ModifyDate = @"修改时间";
static NSString *const HsFileBrowerBriefCell_LastOpenDate = @"上次打开时间";
static NSString *const HsFileBrowerBriefCell_Location = @"位置";

/// MARK: life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"简介";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleDone) target:self action:@selector(barButtonAction:)];
    _dataSource = @[
        HsFileBrowerBriefCell_Type,
        HsFileBrowerBriefCell_Size,
        HsFileBrowerBriefCell_CreateDate,
        HsFileBrowerBriefCell_ModifyDate,
        HsFileBrowerBriefCell_LastOpenDate,
        HsFileBrowerBriefCell_Location,
    ];
    [self setupHeaderView];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [self setupItem];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
    CGFloat marginH = 16.0f;
    CGFloat marginV = 5.0f;
    CGFloat labelWidth = CGRectGetWidth(self.view.bounds) - marginH * 2;
    
    CGSize fitedSize = [_headerNameLabel sizeThatFits:CGSizeMake(labelWidth, kScreenHeight)];

    _headerImageView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    _headerNameLabel.frame = CGRectMake(marginH, CGRectGetMaxY(_headerImageView.frame) + marginV, kScreenWidth - marginH * 2, fitedSize.height);
    _headerTypeLabel.frame = CGRectMake(marginH, CGRectGetMaxY(_headerNameLabel.frame) + marginV, kScreenWidth - marginH * 2, 21);
    _headerOpenButton.frame = CGRectMake(marginH, CGRectGetMaxY(_headerTypeLabel.frame) + marginV, 60, 28);
    _headerOpenButton.layer.cornerRadius = CGRectGetHeight(_headerOpenButton.frame) / 2;
    _headerOpenButton.layer.masksToBounds = YES;
    
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(_headerOpenButton.frame) + marginV);
}

/// MARK: - getter

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.bounces = NO;
    _tableView.rowHeight = 35.0f;
    //_tableView.layer.cornerRadius = 10.0f;
    //_tableView.layer.masksToBounds = YES;
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    return _headerView;
}

- (void)setupHeaderView {
    _headerView = [[UIView alloc] init];
    
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    _headerImageView.layer.shadowOpacity = 0.4;
    _headerImageView.layer.shadowOffset = CGSizeMake(4, 4);
    _headerImageView.layer.shadowColor = UIColor.grayColor.CGColor;
    [_headerView addSubview:_headerImageView];
    
    _headerNameLabel = [[UILabel alloc] init];
    _headerNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _headerNameLabel.textColor = UIColor.blackColor;
    _headerNameLabel.textAlignment = NSTextAlignmentLeft;
    _headerNameLabel.numberOfLines = 0;
    _headerNameLabel.font = [UIFont boldSystemFontOfSize:21.0];
    [_headerView addSubview:_headerNameLabel];

    _headerTypeLabel = [[UILabel alloc] init];
    _headerTypeLabel.textColor = UIColor.grayColor;
    _headerTypeLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [_headerView addSubview:_headerTypeLabel];

    _headerOpenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _headerOpenButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _headerOpenButton.backgroundColor = UIColor.systemBlueColor;
    [_headerOpenButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_headerOpenButton setTitle:@"打开" forState:UIControlStateNormal];
    [_headerOpenButton addTarget:self action:@selector(openButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_headerOpenButton];

}

- (void)setupItem {
    _headerImageView.image = [HsFileBrowerManager imageNameWithItem:_item];
    _headerNameLabel.text = _item.name;
    _headerTypeLabel.text = _item.isDir ? @"文件夹" : @"文件";
    [self.view setNeedsLayout];
    [self.tableView reloadData];
}

/// MARK: - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = UIColor.clearColor;
        cell.textLabel.textColor = UIColor.grayColor;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.detailTextLabel.textColor = UIColor.darkTextColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressAction:)];
        [cell addGestureRecognizer:longPress];
    }
    [self setupCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)setupCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString *title = _dataSource[indexPath.row];
    cell.textLabel.text = title;
    if ([HsFileBrowerBriefCell_Type isEqualToString:title]) {
        cell.detailTextLabel.text = _item.extension;
    } else if ([HsFileBrowerBriefCell_Size isEqualToString:title]) {
        cell.detailTextLabel.text = _item.sizeString;
    } else if ([HsFileBrowerBriefCell_CreateDate isEqualToString:title]) {
        cell.detailTextLabel.text = _item.createDateString;
    } else if ([HsFileBrowerBriefCell_ModifyDate isEqualToString:title]) {
        cell.detailTextLabel.text = _item.modifyDateString;
    } else if ([HsFileBrowerBriefCell_LastOpenDate isEqualToString:title]) {
        cell.detailTextLabel.text = _item.lastOpenDateString;
    } else if ([HsFileBrowerBriefCell_Location isEqualToString:title]) {
        cell.detailTextLabel.text = _item.path;
    }
}

/// MARK: - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 55.0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55.0)];
    CGFloat marginH = 16.0f;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginH, 0, CGRectGetWidth(headerView.bounds) - marginH * 2, CGRectGetHeight(headerView.bounds))];
    headerLabel.text = @"信息";
    headerLabel.font = [UIFont boldSystemFontOfSize:21.0f];
    headerLabel.textColor = UIColor.blackColor;
    [headerView addSubview:headerLabel];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/// MARK: - cell long press

- (void)cellLongPressAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        _indexPathUnderLongPressed = [self.tableView indexPathForCell:(UITableViewCell *)longPress.view];
        CGPoint location = [longPress locationInView:self.view];
        [self showMenuControllerAtPoint:location];
    }
}

- (void)showMenuControllerAtPoint:(CGPoint)location {
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(_copy:)];
    menu.menuItems = @[copyItem];
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
    if (action == @selector(_copy:)) {
        return YES;
    }
    return NO;
}

- (void)_copy:(UIMenuController *)menu {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPathUnderLongPressed];
    if (cell) {
        [UIPasteboard generalPasteboard].string = cell.detailTextLabel.text;
    }
}

- (void)barButtonAction:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.openItem) {
            self.openItem(self, self.item);
        }
    }];
}

@end
