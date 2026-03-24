# Android Emulator Launcher

一个标准 macOS App 工程，用来从桌面或“应用程序”启动本机 Android Emulator AVD。

## 项目结构

- `AndroidEmulatorLauncher.xcodeproj`: Xcode 工程
- `AndroidEmulatorLauncher/AndroidEmulatorApp.swift`: App 入口
- `AndroidEmulatorLauncher/AppDelegate.swift`: 启动逻辑
- `AndroidEmulatorLauncher/Info.plist`: 应用配置
- `AndroidEmulatorLauncher/AppIcon.icns`: 应用图标

## 当前配置

- Android SDK Root: `/opt/homebrew/share/android-commandlinetools`
- AVD Name: `tax35-arm64`
- 启动日志: `/tmp/tax35-emulator.log`

## 本地构建

```bash
xcodebuild \
  -project AndroidEmulatorLauncher.xcodeproj \
  -scheme "Android Emulator" \
  -configuration Release \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## 运行方式

在 Xcode 中运行，或者构建后打开产物 `Android Emulator.app`。

## 说明

这个仓库当前保存的是标准 macOS App 工程代码和图标资源，方便继续调试启动链路、签名和安装流程。
