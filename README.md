# WPJ iOS

这是 `WPJ` 的 iOS 版本项目。这个仓库是基于原来的 Kotlin 版本继续迁移和整理出来的，我希望在保留原项目核心想法的前提下，一边学习 iOS / SwiftUI 开发，一边把这个应用逐步做成一个可持续迭代的版本。

目前这个项目中的大量页面、交互和整理工作，都是在 Codex 协助下逐步生成、修改和完善出来的。对我来说，这个仓库既是一个真实在推进的应用，也是一个学习 iOS 与 AI 协作开发的过程记录。

## 项目背景

最初是因为想要一款简单、轻量、顺手记录物品保质期和过期时间的 App，但市面上没有完全符合自己想法的版本，所以决定自己动手做。

Kotlin 版本已经完成了基础功能，而这个 iOS 仓库则是在那个版本的基础上继续迁移和演进出来的当前实现。

## 当前状态

目前这个 iOS 版本已经完成的内容：

- 启动页与品牌资源接入
- 首页基础布局
- 本地物品列表展示
- 名称搜索过滤
- 新增物品页面
- 生产日期 / 有效日期选择
- 提醒开关与提醒时间选择
- 图片插入（相机 / 相册）
- 本地图片保存与删除
- 本地数据持久化
- 首页卡片左右滑动删除 / 编辑
- 首页卡片展开动画
- 首页爱心雨动画

目前还可以继续完善的内容：

- 提醒功能真正接入系统通知
- 列表和新增页的交互细节继续打磨
- 与 Kotlin 原版更高精度的视觉对齐
- 更完整的异常处理与数据校验
- 更系统的测试与构建验证

## 预览

https://github.com/user-attachments/assets/e9d9fdcc-5f88-4adc-b529-c93df4cbe565

## 技术栈

- Swift
- SwiftUI
- Xcode
- PhotosUI
- UIKit（相机与部分图片能力桥接）

## 本地存储说明

当前项目使用本地 JSON + 本地图片文件的方式保存数据：

- 物品数据保存在应用沙盒 `Documents/items.json`
- 物品图片保存在应用沙盒 `Documents/item_images/`

这意味着：

- 当前没有云同步
- 删除 App 后，本地数据会一起清空

## 运行方式

进入项目目录：

```bash
cd WPJ_IOS
```

使用 Xcode 打开工程：

```bash
open WPJ_IOS.xcodeproj
```

然后在 Xcode 中：

- 选择模拟器或真机
- 直接 `Run`

如果要使用真机调试：

- 需要在 Xcode 中配置可用的签名账号
- 相机功能需要真机环境才能完整验证

## 目录说明

```text
WPJ_IOS/
  AppTheme.swift                 全局主题
  WPJ_IOSApp.swift               应用入口

  Data/
    ItemStore.swift              本地数据与图片存储

  Models/
    StoredItem.swift             物品数据模型
    ReminderOption.swift         提醒选项模型

  ViewModels/
    AddItemViewModel.swift       新增 / 编辑页面状态与逻辑

  Views/
    Core/                        启动页与页面入口
    Home/                        首页、卡片、弹窗、动画
    AddItem/                     新增 / 编辑页面及选择器组件

  Assets.xcassets/
    Brand/                       Logo、Slogan、品牌色
    Colors/                      颜色资源
    Icons/                       图标资源
    Backgrounds/                 背景资源
    Illustrations/               插画资源
    AppIcon.appiconset/          App 图标资源
```

## 项目说明

这个仓库不是一个从零手写、一步一步慢慢整理出来的标准模板项目，而是一个真实在迭代中的学习型项目。

我希望通过这个过程，一边持续学习 iOS 开发，一边借助 Codex 提高迁移和试错效率，把 Kotlin 版本里的想法逐步稳定地落到 iOS 上。
