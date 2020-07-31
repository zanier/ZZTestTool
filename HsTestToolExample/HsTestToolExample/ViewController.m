//
//  ViewController.m
//  HsTestTool
//
//  Created by zanier on 2020/7/1.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ViewController.h"
#import "HsFileBrowerPage.h"
#import "HsPlistBrowerController.h"
#import "HsFileBrowerController.h"
#import "HsConfigBrowerPage.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *dataSource;

@end

@implementation ViewController

static NSString *const ViewController_Plist = @"Plist";
static NSString *const ViewController_Sandbox = @"Sand box";
static NSString *const ViewController_ConfigReader = @"HsConfig";
static NSString *const ViewController_testFile =  @"测试文件";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    _dataSource = @[
        ViewController_Plist,
        ViewController_Sandbox,
        ViewController_ConfigReader,
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

- (void)move {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 获取document目录
    NSString *documentDirectory = [paths objectAtIndex:0];
    // 追加文件系统路径
    NSString *path = documentDirectory;//XXX文件名
    
    NSLog(@"path = %@", path);
    NSBundle *testToolBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[HsTestBaseViewController class]] pathForResource:@"TestBundle" ofType:@"bundle"]];
    path = [path stringByAppendingPathComponent:@"TestBundle.bundle"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //NSString *filePath = [[NSBundle mainBundle] pathForResource:resource ofType:nil];
        //NSLog(@"数据库本地filePath --- %@", filePath);
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:testToolBundle.bundlePath toPath:path error:&error];
        if (error) {
            NSLog(@"%@", error.description);
        }
    }
    
}

///MARK: - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = _dataSource[indexPath.row];
    if ([ViewController_Plist isEqualToString:title]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        HsPlistBrowerController *plistVC = [[HsPlistBrowerController alloc] initWithPlistFilePath:path];
        [self.navigationController pushViewController:plistVC animated:YES];
    } else if ([ViewController_Sandbox isEqualToString:title]) {
        [self.navigationController pushViewController:[[HsFileBrowerController alloc] init] animated:YES];
    } else if ([ViewController_testFile isEqualToString:title]) {
        [self move];
    } else if ([ViewController_ConfigReader isEqualToString:title]) {
        NSMutableArray *array1 = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        NSMutableArray *array3 = [NSMutableArray array];
        NSMutableArray *array4 = [NSMutableArray array];
        NSString *str;
        for (int i = 0; i < 25; i++) {
            str = [NSString stringWithFormat:@"NSString %i", i];
            [array1 addObject:str];
            if (i % 2 == 0) [array2 addObject:str];
            if (i % 4 != 0) [array3 addObject:str];
            if (i % 5 == 0) [array4 addObject:str];
        }
        [self.navigationController pushViewController:[[HsConfigBrowerPage alloc] initWithObjectsDictionary:@{
            @"system Dict" : array1,
            @"file Dict" : array2,
            @"cache Dict" : array3,
            @"whatever" : array4,
        }] animated:YES];
    }
}


@end
