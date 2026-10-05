# GXDE DTK6
GXDE的DTK6库，请注意本包与Deepin的DTK6冲突。

## 版本
| flake attr | 上游 | pin | out 内容 | dev 内容 |
| --- | --- | --- | --- | --- |
| `dtk5common` | GXDE-OS/dtk5common | tag `6.7.43` | `share/dsg/configs/` | `lib/cmake/{Dtk,Dtk6,DtkBuildHelper}` |
| `dtk6log` | GXDE-OS/dtk6log | tag `0.0.6-1` | `libdtk6log.so.0*` | `include/dtk6/DLog`、cmake、pc、qmake |
| `dtk6core` | GXDE-OS/dtk6core | tag `6.0.48` | `libdtk6core.so.6*`、`libexec/dtk6/DCore` | `include/dtk6/DCore`、cmake、pc、qmake |
| `dtk6gui` | GXDE-OS/dtk6gui | tag `6.0.48` | `libdtk6gui.so.6*`、`libexec/dtk6/DGui` | `include/dtk6/DGui`、cmake、pc、qmake |
| `dtk6widget` | GXDE-OS/dtk6widget | tag `6.0.48-gxde1` | `libdtk6widget.so.6*`、`lib/dtk6/DWidget`、`share/dtk6` | `include/dtk6/DWidget`、cmake、pc、qmake、designer 插件 |
| `dtk6declarative` | GXDE-OS/dtk6declarative | tag `6.0.48-gxde1` | `libdtk6declarative.so.6*`、`lib/qt6/qml/…` | `include/dtk6/DDeclarative`、cmake、pc、qmake |
| `dde-qt6platform-plugins` | GXDE-OS/dde-qt6platform-plugins | tag `6.0.48-1` | `lib/qt-6/plugins/platforms/libdxcb.so` | — |
| `qt6integration` | GXDE-OS/qt6integration | tag `6.0.35` | `lib/qt-6/plugins/{iconengines,imageformats,platformthemes,styles}` | — |
| `all` (`default`) | — | — | 全部模块 out+dev 的汇总 | |

## 说明
- Qt 6.10/6.11 的兼容补丁取自 GXDE 的 Fedora 打包（`dtk6core` 1 个、`dtk6widget` 2 个），放在 `nix/patches/` 下。
- nixpkgs 的 `qtbase` 不安装 xcbqpa 私有头，`dde-qt6platform-plugins` 因此从**同版本 Qt 源码**里抽取，而不是用上游 vendored 的旧版本头（最高只到 6.10.2）。
- 两个插件包的安装路径改为 nixpkgs 的 `qtPluginPrefix`（`lib/qt-6/plugins`），否则 Qt 运行时找不到它们（上游默认写死 `lib/qt6/plugins`）。
- `dtk5common` 与 [GXDE-NIX/gxde-dtk5](https://gitee.com/gxde-nix/gxde-dtk5) 里的是同一个包（DTK 的 CMake 支持）。

## 使用脚本构建
### 基本使用
```bash
$ chmod a+x ./build-nix
$ ./build-nix
```

### 使用说明
```
用法: build-nix [选项] [目标]

从本地目录构建Nix包。

选项:
  -L, --log       构建时打印日志
      --rebuild   重新构建以检查可复现性
      --cleanup   清理产物
  -h, --help      打印帮助

目标:
  一个.nix文件或者flake installable，例如.#package。
  默认在当前目录查找。
```

## 许可证
(C) 2026 CharOfString.

本仓库的打包部分（Nix 表达式、`build-nix`、文档）以 [MIT](./LICENSE) 协议授权。

[`nix/patches/`](./nix/patches) 下的补丁修改的是对应上游项目的源码，按**原仓库协议**提供：

| 补丁 | 上游 | 协议 |
| --- | --- | --- |
| `dtk6core/0001-qt-6.11-file-engine.patch` | GXDE-OS/dtk6core | LGPL-3.0-or-later |
| `dtk6widget/0001-qt-6.10-private-api.patch` | GXDE-OS/dtk6widget | LGPL-3.0-or-later |
| `dtk6widget/0002-qt-6.11-completer-header.patch` | GXDE-OS/dtk6widget | LGPL-3.0-or-later |
