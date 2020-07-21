# HSTestTool

2020-07-16，zz

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

1. 下载源码，将 HSTestTool 文件夹拖入工程；
2. 在需要设置入口的地方导入测试工具入口页面头文件 ``；
3. 通过进入 `` 测试工具入口页面开始使用各类功能。

**`QuickLook.framework`** 提供了部分文件类型的预览功能，例如txt、PDF、图片等文件。如要使用该功能，请在集成时添加 **`QuickLook.framework`** 框架，并在 `HsTestToolDefine.h` 文件中打开宏定义开关。

```c
/// <QuickLook> 框架支持
#define HSTESTTOOL_NEED_QUICKLOOK
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

## 1 PlistBrower

.plist文件浏览页面



## 2 SandBoxBrower

沙盒文件浏览页面



## TODO