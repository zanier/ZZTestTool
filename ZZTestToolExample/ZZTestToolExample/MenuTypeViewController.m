//
//  MenuTypeViewController.m
//  ZZTestToolExample
//
//  Created by handsome on 2020/8/6.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "MenuTypeViewController.h"

@interface MenuTypeViewController () <UITableViewDataSource, UITableViewDelegate, UIContextMenuInteractionDelegate> {
    NSIndexPath *_indexPath;
}

@property (nonatomic, copy) NSArray<NSString *> *children;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MenuTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        _children = [self menuIdentifiers];
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
    } else {
        // Fallback on earlier versions
    }
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
        if (@available(iOS 13.0, *)) {
            UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
            cell.userInteractionEnabled = YES;
            [cell addInteraction:interaction];
        }
    }
    NSString *text = _children[indexPath.row];
    cell.textLabel.text = text;
    return cell;
}

- (void)showMenu {
    
}

//- (UIContextMenuInteraction *)contextMenuInteraction  API_AVAILABLE(ios(13.0)){
//    UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
//    return interaction;
//}

- (UIMenu *)menuWithIdentifier:(UIMenuIdentifier)identifier API_AVAILABLE(ios(13.0)) {
    UIAction *action1 = [UIAction actionWithTitle:@"复制" image:nil identifier:@"qwe" handler:^(__kindof UIAction * _Nonnull action) {
    
    }];
    UIAction *action2 = [UIAction actionWithTitle:@"拷贝" image:nil identifier:@"qwe" handler:^(__kindof UIAction * _Nonnull action) {
    
    }];
    UIAction *action3 = [UIAction actionWithTitle:@"移动" image:nil identifier:@"qwe" handler:^(__kindof UIAction * _Nonnull action) {
    
    }];
    UIAction *action4 = [UIAction actionWithTitle:@"删除" image:nil identifier:@"qwe" handler:^(__kindof UIAction * _Nonnull action) {
    
    }];

    UIMenu *menu = [UIMenu menuWithTitle:identifier image:nil identifier:identifier options:(UIMenuOptionsDisplayInline) children:@[
        action1,
        action2,
        action3,
        action4,
    ]];
    return menu;
}

/// MARK: - <UIContextMenuInteractionDelegate>

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location  API_AVAILABLE(ios(13.0)) {
    UITableViewCell *cell = interaction.view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *identifier = _children[indexPath.row];
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:@"qwe" previewProvider:^UIViewController * _Nullable{
        
        return nil;
    } actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        return [self menuWithIdentifier:identifier];
    }];
    return configuration;
}

- (NSArray *)menuIdentifiers API_AVAILABLE(ios(13.0)) {
    NSArray *array = @[
        UIMenuApplication,
        /// File menu top-level menu
        UIMenuFile,
        /// Edit menu top-level menu
        UIMenuEdit,
        /// View menu top-level menu
        UIMenuView,
        /// Window menu top-level menu
        UIMenuWindow,
        /// Help menu top-level menu
        UIMenuHelp,
        /// -- Identifiers for Application submenus
        /// About menu
        UIMenuAbout,
        /// Preferences menu
        UIMenuPreferences,
        /// Services menu
        UIMenuServices,
        /// Hide, Hide Others, Show All menu
        UIMenuHide,
        /// Quit menu
        UIMenuQuit,
        /// -- Identifiers for File submenus
        /// New scene menu
        UIMenuNewScene,
        /// Close menu
        UIMenuClose,
        /// Print menu
        UIMenuPrint,
        /// -- Identifiers for Edit submenus
        /// Undo, Redo menu
        UIMenuUndoRedo,
        /// Cut, Copy, Paste, Delete, Select, Select All menu
        UIMenuStandardEdit,
        /// Find menu; empty in the default menubar configuration. Applications should use this when adding their own Find-related menu items.
        UIMenuFind,
        /// Replace..., Transliterate Chinese menu
        UIMenuReplace,
        /// Share menu
        UIMenuShare,
        /// Bold, Italics, Underline  menu
        UIMenuTextStyle,
        /// Spelling menu contained within Edit menu
        UIMenuSpelling,
        /// Show Spelling, Check Document Now menu
        UIMenuSpellingPanel,
        /// Check Spelling While Typing and other spelling and grammar-checking options menu
        UIMenuSpellingOptions,
        /// Substitutions menu contained within Edit menu
        UIMenuSubstitutions,
        
        // Show Substitutions menu
        UIMenuSubstitutionsPanel,
        /// Smart Copy, Smart Paste, Smart Quotes, and other substitution options menu
        UIMenuSubstitutionOptions,
        /// Transformations menu contained within Edit menu (contains Make Uppercase, Make Lowercase, Capitalize)
        UIMenuTransformations,
        /// Speech menu contained within Edit menu (contains Speak, Speak..., Pause)
        UIMenuSpeech,
        /// Lookup menu
        UIMenuLookup,
        /// Learn menu
        UIMenuLearn,
        /// Format top-level menu
        UIMenuFormat,
        /// Font menu contained within Format menu (contains UIMenuTextStyle)
        UIMenuFont,
        /// Bigger and Smaller menu
        UIMenuTextSize,
        /// Show Colors menu
        UIMenuTextColor,
        /// Copy Style and Paste Style menu
        UIMenuTextStylePasteboard,
        /// Text menu contained within Format menu (contains UIMenuAlignment and UIMenuWritingDirection)
        UIMenuText,
        /// Default, Right to Left, Left to Right menu
        UIMenuWritingDirection,
        /// Align Left, Center, Justify, Align Right menu
        UIMenuAlignment,
        /// -- Identifiers for View submenus
        /// Show/Hide and Customize Toolbar menu
        UIMenuToolbar,
        /// Fullscreen menu
        UIMenuFullscreen,
        /// -- Identifiers for Window submenus
        /// Minimize, Zoom menu
        UIMenuMinimizeAndZoom,
        /// Bring All to Front, Arrange in Front menu
        UIMenuBringAllToFront,
        /// Root-level menu
        UIMenuRoot,
    ];
    return array;
}

@end
