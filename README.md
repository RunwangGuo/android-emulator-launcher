# Android Emulator Launcher

这个项目是一个简单的 macOS 启动器，用来把本机已经配置好的 Android Emulator AVD 包装成一个可以直接双击打开的桌面应用。

## Android Emulator AVD 是怎么装的

这里用的是本机的 Android command line tools，而不是单独依赖 Android Studio 图形界面。先安装 `adb`、emulator 和对应的 command line tools，再下载 Android 35 的系统镜像，最后基于这个镜像创建了一个名叫 `tax35-arm64` 的 AVD。

这个 AVD 可以理解成一台预先配置好的“虚拟安卓手机”。后面无论是在终端里启动，还是通过这个 macOS 启动器启动，实际拉起的都是它。

当前本机使用的主要配置是：

- Android SDK Root: `/opt/homebrew/share/android-commandlinetools`
- AVD Name: `tax35-arm64`
- 启动日志: `/tmp/tax35-emulator.log`

## 这个项目是干什么的

`android-emulator-launcher` 本身不是模拟器，也不包含安卓系统镜像。它只是一个标准的 macOS App 工程，作用是把“启动本机已有的 Android Emulator AVD”这件事做成一个更顺手的图形化入口。

换句话说，这个项目解决的是“怎么从 macOS 上像打开普通应用一样去启动模拟器”，而不是“怎么安装安卓环境”。

项目里主要包含几部分：

- `AndroidEmulatorLauncher.xcodeproj`：Xcode 工程
- `AndroidEmulatorLauncher/AndroidEmulatorApp.swift`：应用入口
- `AndroidEmulatorLauncher/AppDelegate.swift`：启动 AVD 的主要逻辑
- `AndroidEmulatorLauncher/Info.plist`：应用配置
- `AndroidEmulatorLauncher/AppIcon.icns`：应用图标

## 本地构建

```bash
xcodebuild \
  -project AndroidEmulatorLauncher.xcodeproj \
  -scheme "Android Emulator" \
  -configuration Release \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## 说明

这个仓库目前保存的是标准 macOS App 工程代码和图标资源，方便后续继续调整启动逻辑、图标和打包方式。
