////
////  HsHiddenFunctionPage.m
////  TZYJ_IPhone
////
////  Created by yanChengYi(wangyu07901) on 16/5/12.
////
////
//
//#import "HsHiddenFunctionPage.h"
//#import <HsCommonEngine/HsNetworkCenter.h>
//#import <HsCommonEngine/HsURLUtil.h>
//#import <HsCommonEngine/SandboxUtil.h>
//#import <HsCommonEngine/WHDebugToolManager.h>
//#import <HsCommonEngine/HsMonitorUtil.h>
//#import <HsCommonEngine/HsConsole.h>
//
//#define kHsBaseSpaceLeft        15.0
//#define kHsBaseSectionHeight    30.0
//
//#import "HsPlistBrowerPage.h"
//
//static NSString *const HsDebugPage_AppId = @"";
//
//static NSString *const HsDebugPageCellTitle_SystemVersion = @"系统版本";
//static NSString *const HsDebugPageCellTitle_SystemName = @"系统名称";
//static NSString *const HsDebugPageCellTitle_DeviceModel = @"设备类型";
//static NSString *const HsDebugPageCellTitle_DeviceName = @"设备名称";
//static NSString *const HsDebugPageCellTitle_AppName = @"应用名称";
//static NSString *const HsDebugPageCellTitle_AppVersion = @"应用版本";
//static NSString *const HsDebugPageCellTitle_AppUpdatedVersion = @"最新版本";
//static NSString *const HsDebugPageCellTitle_AppBuildVersion = @"构建版本";
//
//static NSString *const HsDebugPageCellTitle_ResourceHost = @"基线地址";
//static NSString *const HsDebugPageCellTitle_tcpHost = @"TCP Host";
//static NSString *const HsDebugPageCellTitle_sslHost = @"SSL Host";
//
//static NSString *const HsDebugPageCellTitle_crash = @"崩溃日志";
//static NSString *const HsDebugPageCellTitle_sandbox = @"沙盒文件";
//static NSString *const HsDebugPageCellTitle_jfInfoPlist = @"JF-info.plist";
//
//static NSString *const HsDebugPageCellTitle_log = @"日志收集";
//static NSString *const HsDebugPageCellTitle_performance = @"CPU / Memory / FPS";
//
//@interface HsHiddenFunctionPage () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
//
//    BOOL _showPerformance;
//    BOOL _openCrashCatch;
//
//    NSString *_appName;
//    NSString *_appVersion;
//    NSString *_appUpdatedVersion;
//    NSString *_appBuildVersion;
//
//    NSString *_systemVersion;
//    NSString *_systemName;
//    NSString *_deviceModel;
//    NSString *_deviceName;
//
//    NSString *_sslHost;
//    NSString *_tcpHost;
//    NSString *_resourceHost;
//}
//
//@property (nonatomic, strong) UITableView *tableView;
//
//@property (nonatomic, copy) NSArray *sectionTitles;
//@property (nonatomic, copy) NSArray<NSArray<NSString *> *> *dataArray;
//
//@end
//
//@implementation HsHiddenFunctionPage
//
///// MARK: - FactoryCreation
//
//+ (id)createPage:(NSDictionary*)params {
//    HsHiddenFunctionPage *page = [[HsHiddenFunctionPage alloc] init];
//    page.title = @"调试工具";
//    return page;
//}
//
///// MARK: - Life cycle
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    _sectionTitles = @[
//        @"信息",
//        @"站点",
//        @"日志",
//        @"监控",
//    ];
//
//    _dataArray = @[
//        @[
//            HsDebugPageCellTitle_SystemVersion,
//            //HsDebugPageCellTitle_SystemName,
//            //HsDebugPageCellTitle_DeviceModel,
//            HsDebugPageCellTitle_DeviceName,
//            HsDebugPageCellTitle_AppName,
//            HsDebugPageCellTitle_AppVersion,
//            HsDebugPageCellTitle_AppBuildVersion,
//            HsDebugPageCellTitle_AppUpdatedVersion,
//        ],
//        @[
//            HsDebugPageCellTitle_ResourceHost,
//            HsDebugPageCellTitle_tcpHost,
//            HsDebugPageCellTitle_sslHost,
//        ],
//        @[
//            HsDebugPageCellTitle_crash,
//            HsDebugPageCellTitle_sandbox,
//            HsDebugPageCellTitle_jfInfoPlist,
//        ],
//        @[
//            HsDebugPageCellTitle_log,
//            HsDebugPageCellTitle_performance,
//        ],
//    ];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self getInfo];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    });
//    [self.view addSubview:self.tableView];
//}
//
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//
//}
//
//- (void)getInfo {
//    NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
//    NSLog(@"[NSBundle mainBundle].infoDictionary = %@", infoDictionary);
//    _appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    _appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    _appBuildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
//
//    UIDevice *currentDevice = [UIDevice currentDevice];
//    _deviceName = currentDevice.name;
//    _systemName = currentDevice.systemName;
//    _systemVersion = currentDevice.systemVersion;
//    _deviceModel = currentDevice.model;
//
//    _sslHost = [[HsNetworkCenter getInstance] readLinkAddr:NetworkConnectionSSL];
//    _tcpHost = [[HsNetworkCenter getInstance] readLinkAddr:NetworkConnectionSocket];
//    _resourceHost = [HsConfig sharedManager].appBaseLineName;
//
//    [self getAppStoreVersion];
//}
//
//- (void)getAppStoreVersion {
//    if (!HsDebugPage_AppId || HsDebugPage_AppId.length <= 0) {
//        return;
//    }
//    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", HsDebugPage_AppId];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
//    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSArray *array = json[@"results"];
//    for (NSDictionary *dic in array) {
//        _appUpdatedVersion = [dic valueForKey:@"version"];
//        break;
//    }
//}
//
///// MARK: - Lazy load
//
//- (UITableView *)tableView {
//    if (_tableView) {
//        return _tableView;
//    }
//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 88)];
//    [self.view addSubview:_tableView];
//    return _tableView;
//}
//
/////MARK: - <UITableViewDataSource>
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return _dataArray.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _dataArray[section].count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *const cellIdentifer = @"cellIdentifer";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifer];
//    }
//    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
//    [self configCell:cell atIndexPath:indexPath];
//    return cell;
//}
//
//- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    NSString *title = _dataArray[indexPath.section][indexPath.row];
//    if ([HsDebugPageCellTitle_SystemVersion isEqualToString:title]) {
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", _systemName, _systemVersion];
//    } else if ([HsDebugPageCellTitle_SystemName isEqualToString:title]) {
//        cell.detailTextLabel.text = _systemName;
//    } else if ([HsDebugPageCellTitle_DeviceModel isEqualToString:title]) {
//        cell.detailTextLabel.text = _deviceModel;
//    } else if ([HsDebugPageCellTitle_DeviceName isEqualToString:title]) {
//        cell.detailTextLabel.text = _deviceName;
//    } else if ([HsDebugPageCellTitle_AppName isEqualToString:title]) {
//        cell.detailTextLabel.text = _appName;
//    } else if ([HsDebugPageCellTitle_AppVersion isEqualToString:title]) {
//        cell.detailTextLabel.text = _appVersion;
//    } else if ([HsDebugPageCellTitle_AppBuildVersion isEqualToString:title]) {
//        cell.detailTextLabel.text = _appBuildVersion;
//    } else if ([HsDebugPageCellTitle_AppUpdatedVersion isEqualToString:title]) {
//        cell.detailTextLabel.text = _appUpdatedVersion;
//    } else if ([HsDebugPageCellTitle_ResourceHost isEqualToString:title]) {
//        cell.detailTextLabel.text = _resourceHost;
//    } else if ([HsDebugPageCellTitle_tcpHost isEqualToString:title]) {
//        cell.detailTextLabel.text = _tcpHost;
//    } else if ([HsDebugPageCellTitle_sslHost isEqualToString:title]) {
//        cell.detailTextLabel.text = _sslHost;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//}
//
/////MARK: - <UITableViewDelegate>
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return kHsBaseSectionHeight;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    // nameLabel
//    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.frame = CGRectMake(kHsBaseSpaceLeft, 0, (MAIN_SCREEN_WIDTH-kHsBaseSpaceLeft*2), kHsBaseSectionHeight);
//    nameLabel.font = HsFontBold(15);
//    nameLabel.textColor = [HsPageConfig colorFromString:@"#333333"];
//    nameLabel.text = _sectionTitles[section];
//    [headerView addSubview:nameLabel];
//    return headerView;
//}
//
//
////static NSString *const HsDebugPageCellTitle_Res = @"基线地址";
////static NSString *const HsDebugPageCellTitle_tcp = @"TCP Host";
////static NSString *const HsDebugPageCellTitle_ssl = @"SSL Host";
////
////static NSString *const HsDebugPageCellTitle_crash = @"奔溃日志";
////static NSString *const HsDebugPageCellTitle_sandbox = @"沙盒文件";
////static NSString *const HsDebugPageCellTitle_jfInfoPlist = @"JF-info.plist";
////
////static NSString *const HsDebugPageCellTitle_log = @"日志收集";
////static NSString *const HsDebugPageCellTitle_performance = @"CPU / Memory / FPS";
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSString *title = _dataArray[indexPath.section][indexPath.row];
//    if ([HsDebugPageCellTitle_jfInfoPlist isEqualToString:title]) {
//        // 查看 jf-info.plist
//        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"JF-info.plist.encode" ofType:nil];
//        HsShowPage(@"plistBrowerPage", @{@"HsPlistBrowerPagePlsitFilePathCreateKey":dataPath});
//    } else if ([HsDebugPageCellTitle_sandbox isEqualToString:title]) {
//        // 浏览沙盒文件
//        //[self showSandboxBrowser];
//        HsShowPage(@"fileBrowerPage", nil);
//    } else if ([HsDebugPageCellTitle_performance isEqualToString:title]) {
//        // 运行性能监控窗
//        if (_showPerformance) {
//            [self hidePerformance];
//        } else {
//            [self showPerformance];
//        }
//    } else if ([HsDebugPageCellTitle_jfInfoPlist isEqualToString:title]) {
//    } else if ([HsDebugPageCellTitle_jfInfoPlist isEqualToString:title]) {
//    } else if ([HsDebugPageCellTitle_jfInfoPlist isEqualToString:title]) {
//    }
//}
//
///// MARK: - action
//
///// 开启日志记录
//- (void)openMonitor {
//    [HsMonitorUtil shareInstance].isAppMonitorOpen = YES;
//}
//
///// 关闭日志记录
//- (void)closeMonitor {
//    [HsMonitorUtil shareInstance].isAppMonitorOpen = NO;
//}
//
///// 展示沙盒目录
//- (void)showSandboxBrowser {
//    [[SandboxUtil sharedInstance] showSandboxBrowser];
//}
//
///// 清除本地日志
//- (void)clearLogs {
//    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/Monitor/",NSHomeDirectory()];
//    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//}
//
///// 显示系统运行参数视图
//- (void)showPerformance {
//    _showPerformance = YES;
//    [[WHDebugToolManager sharedInstance] showWith:DebugToolTypeMemory | DebugToolTypeCPU | DebugToolTypeFPS];
//    [[HsConsole shareInstance] startConsole];
//}
//
///// 移除系统运行参数视图
//- (void)hidePerformance {
//    _showPerformance = NO;
//    [[WHDebugToolManager sharedInstance] hide];
//    [[HsConsole shareInstance] closeConsole];
//}
//
///// 获取沙盒中指定文件路径的内容
///// @param fileName 沙盒文件路径
//- (NSString *)fileContentAtFilePath:(NSString *)fileName {
//    NSString *filePath = [HsURLUtil dataFilePathWithFileName:fileName WithDirType:NSDocumentDirectory];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        [HsPopupManager show:[NSString stringWithFormat:@"暂未创建文件%@", fileName]];
//        return nil;
//    }
//    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath: filePath];
//    NSData *data = [file readDataToEndOfFile];
//    NSString *fileContent = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
//    return fileContent;
//}
//
//@end
