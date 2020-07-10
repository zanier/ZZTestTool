//
//  ViewController.m
//  HsTestTool
//
//  Created by handsome on 2020/7/1.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "ViewController.h"
#import "HsFileBrowerPage.h"
#import "HsPlistBrowerPage.h"
#import "HsFileBrowerController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *dataSource;

@end

@implementation ViewController

static NSString *const ViewController_Plist = @"Plist";
static NSString *const ViewController_Sandbox = @"Sand box";
static NSString *const ViewController_testFile = @"测试文件";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    _dataSource = @[
        ViewController_Plist,
        ViewController_Sandbox,
        ViewController_testFile,
    ];
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 88)];
    [self.view addSubview:_tableView];
    return _tableView;
}

///MARK: - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifer = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

///MARK: - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = _dataSource[indexPath.row];
    if ([ViewController_Plist isEqualToString:title]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        [self.navigationController pushViewController:[[HsPlistBrowerPage alloc] initWithPlistFilePath:path] animated:YES];
    } else if ([ViewController_Sandbox isEqualToString:title]) {
        [self.navigationController pushViewController:[[HsFileBrowerController alloc] init] animated:YES];
    } else if ([ViewController_testFile isEqualToString:title]) {
        
    }
}

- (void)move {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 获取document目录
    NSString *documentDirectory = [paths objectAtIndex:0];
    // 追加文件系统路径
    NSString *path = documentDirectory;//XXX文件名
    
    NSLog(@"path = %@", path);
    NSArray *resources = @[
        
    ];
    for (NSString *resource in resources) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:nil];
            NSLog(@"数据库本地filePath --- %@", filePath);
            [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:path error:nil];
        }
    }
    
    NSBundle *testToolBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[HsTestBaseViewController class]] pathForResource:@"TestBundle" ofType:@"bundle"]];
//    testToolBundle.all
}

@end
