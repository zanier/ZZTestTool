# HSTestTool

2020-07-22，zz

## 介绍

该项目为xx程序测试工具，以帮助解决开发过程中遇到的部分问题，提高开发质量与效率。

该工具包含与计划实现功能如下：

- [x] App 信息收集页面。
- [x] 沙盒文件浏览工具。
- [x] Plist 文件浏览编辑工具。
- [x] 运行性能监控工具。
- [ ] 错误日志收集整理工具。 

## 使用

#### 手动导入

1. 下载源码，将 `HSTestTool` 文件夹拖入工程；
2. 导入文件预览库 `QuickLook.framework`；
3. 在需要设置入口的地方导入测试工具入口页面头文件；
4. 通过进入测试工具入口页面开始使用工具。

#### 自动集成

目前暂未支持。

#### 注意

Common 文件夹下包含基类、通用工具、图片等资源。

`HsTestBaseViewController ` 是工具内所有 ViewController 的基类。鉴于工程中一般包含宏定义`HsGlobalDefine_h`，所以通过该宏定义来决定其父类，使其能够执行工程中通用的页面逻辑，如跳转逻辑 `createPage:`。

```objective-c
#import <UIKit/UIKit.h>
#ifdef HsGlobalDefine_h
#import <HsBusinessEngine/HsBaseViewController.h>
@interface HsTestBaseViewController : HsBaseViewController
#else
@interface HsTestBaseViewController : UIViewController
#endif
// ....
@end
```

#### QuickLook.framework

**`QuickLook.framework`** 是 iOS 提供的文件预览库，例如 `txt`、`PDF`、图片等文件的预览，主要用于沙盒文件浏览工具 `SandBoxBrower`。若不想使用该功能，请移除该框架，并在 `HsTestToolConfig.h` 文件中注释宏定义开关 `HSTESTTOOL_NEED_QUICKLOOK`。默认开启。

```c
/// <QuickLook> 框架支持
#define HSTESTTOOL_NEED_QUICKLOOK
```

#### 图片资源

`HsTestTool.bundle` 包含了工具所需的图片等资源。若考虑到包的体积不想引入图片资源，则移除该 `bundle` 并在 `HsTestToolConfig.h` 文件中注释宏定义开关 `HSTESTTOOL_NEED_RESOURCEBUNDLE`。默认开启。

```objective-c
/// HsTestTool.bundle 图片资源支持
#define HSTESTTOOL_NEED_RESOURCEBUNDLE
```



## App 信息收集

该页面展示了手机与 App 的基础信息，以方便信息的收集。

* 系统版本：运行系统的版本，如
* 系统名称：系统的名称，如
* 设备类型：手机的类型
* 设备名称：
* 应用名称：App 的名称（Display Name）。`[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]`
* 应用版本：
* 最新版本：AppStore 的最新版本。从 http://itunes.apple.com/lookup?id=%@ 获取 AppStore 中的应用信息，从中获取最新版本。
* 构建版本：当前 App 的构建版本。
* 基线地址：当前项目所属的基线地址名称。
* TCP Host：
* SSL Host：



## PlistBrower

Plist 文件浏览工具，页面如下所示：

<img src="/Users/handsome/Desktop/workplace/HsTestTool/pics/plist_brower_01.PNG" alt="plist_brower_01" style="zoom: 25%;" /> <img src="/Users/handsome/Desktop/workplace/HsTestTool/pics/plist_brower_02.PNG" alt="plist_brower_02" style="zoom:25%;" />

#### 使用说明

`HsPlistBrowerController` 是Plist 浏览页面的根页面，头文件声明：

```objective-c
/// `createPage:` 参数中基本类型对象的key
static NSString *const HsPlistBrowerPageObjectCreateKey = @"HsPlistBrowerPageObjectCreateKey";
/// `createPage:` 参数中Plist文件路径的key
static NSString *const HsPlistBrowerPagePlsitFilePathCreateKey = @"HsPlistBrowerPagePlsitFilePathCreateKey";

/// Plist 文件浏览页面
@interface HsPlistBrowerController : HsTestBaseViewController

/// 工程创建方法，参数内容参考上面的 key
+ (instancetype)createPage:(nullable NSDictionary*)params;

/// 初始化方法
/// @param anObject 基本类型数据，如NSArray、NSDictionary、NSString、NSNumber、NSData等
- (instancetype)initWithObject:(nullable id)anObject;

/// 初始化方法
/// @param path plist文件路径
- (instancetype)initWithPlistFilePath:(nullable NSString *)path;

/// plist 根结点数据
@property (nonatomic, nullable, strong) id object;

/// 根结点文件（.plist）路径
@property (nonatomic, nullable, copy) NSString *path;

@end
```

#### 使用

```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
HsPlistBrowerController *plistVC = [[HsPlistBrowerController alloc] initWithPlistFilePath:path];
[self.navigationController pushViewController:plistVC animated:YES];
```



## SandBoxBrower

沙盒文件浏览页面，页面如下所示：

<img src="/Users/handsome/Desktop/workplace/HsTestTool/pics/sandbox_brower_01.PNG" alt="sandbox_brower_01" style="zoom:25%;" /><img src="/Users/handsome/Desktop/workplace/HsTestTool/pics/sandbox_brower_02.PNG" alt="sandbox_brower_02" style="zoom:25%;" />

#### 使用

主页面头文件声明：

```objective-c
/// `createPage:` 参数中基本根目录的key
static NSString *const HsFileBrowerControllerRootPathKey = @"HsFileBrowerControllerRootPathKey";

/// 沙盒文件浏览页面
@interface HsFileBrowerController : HsTestBaseViewController

/// 工程创建方法，参数内容参考上面的 key
+ (instancetype)createPage:(nullable NSDictionary*)params;

/// 初始化方法
/// @param rootPath 根目录文件路径，传 nil 则进入沙盒根目录
- (instancetype)initWithRootPath:(nullable NSString *)rootPath;

/// 根目录文件路径
@property (nonatomic, copy) NSString *rootPath;

@end
```

