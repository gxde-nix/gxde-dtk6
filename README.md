# GXDE DTK6
GXDE's DTK6 libraries. Please note that this package conflicts with Deepin's DTK6.

## Version
| flake attr | Upstream | pin | out | dev |
| --- | --- | --- | --- | --- |
| `dtk5common` | GXDE-OS/dtk5common | tag `6.7.43` | `share/dsg/configs/` | `lib/cmake/{Dtk,Dtk6,DtkBuildHelper}` |
| `dtk6log` | GXDE-OS/dtk6log | tag `0.0.6-1` | `libdtk6log.so.0*` | `include/dtk6/DLog`, cmake, pc, qmake |
| `dtk6core` | GXDE-OS/dtk6core | tag `6.0.48` | `libdtk6core.so.6*`, `libexec/dtk6/DCore` | `include/dtk6/DCore`, cmake, pc, qmake |
| `dtk6gui` | GXDE-OS/dtk6gui | tag `6.0.48` | `libdtk6gui.so.6*`, `libexec/dtk6/DGui` | `include/dtk6/DGui`, cmake, pc, qmake |
| `dtk6widget` | GXDE-OS/dtk6widget | tag `6.0.48-gxde1` | `libdtk6widget.so.6*`, `lib/dtk6/DWidget`, `share/dtk6` | `include/dtk6/DWidget`, cmake, pc, qmake, designer plugin |
| `dtk6declarative` | GXDE-OS/dtk6declarative | tag `6.0.48-gxde1` | `libdtk6declarative.so.6*`, `lib/qt6/qml/…` | `include/dtk6/DDeclarative`, cmake, pc, qmake |
| `dde-qt6platform-plugins` | GXDE-OS/dde-qt6platform-plugins | tag `6.0.48-1` | `lib/qt-6/plugins/platforms/libdxcb.so` | — |
| `qt6integration` | GXDE-OS/qt6integration | tag `6.0.35` | `lib/qt-6/plugins/{iconengines,imageformats,platformthemes,styles}` | — |
| `all` (`default`, `gxde-dtk6`) | — | — | aggregate of the seven DTK6 modules' out + dev (`dtk5common` excluded, see Notes) | |

## Notes
- The Qt 6.10/6.11 compatibility patches come from GXDE's Fedora packaging (one for `dtk6core`, two for `dtk6widget`) and live in `nix/patches/`.
- nixpkgs' `qtbase` does not install the xcbqpa private headers, so `dde-qt6platform-plugins` extracts them from the **matching Qt source** instead of using the vendored, older set from upstream (which stops at 6.10.2).
- Both plugin packages install into nixpkgs' `qtPluginPrefix` (`lib/qt-6/plugins`), otherwise Qt cannot find them at runtime (upstream hardcodes `lib/qt6/plugins`).
- `dtk5common` is the same package as the one in [GXDE-NIX/gxde-dtk5](https://gitee.com/gxde-nix/gxde-dtk5) (DTK's CMake support); because it ships `lib/cmake/{Dtk,Dtk6,DtkBuildHelper}` and `share/dsg/configs`, it is not bundled into the aggregate — otherwise `nix profile add` of both `gxde-dtk5` and `gxde-dtk6` would abort with a file conflict.

## Building via Script
### Basic Instructions
```bash
$ chmod a+x ./build-nix
$ ./build-nix
```

### Usage
```
Usage: build-nix [options] [target]

Build a Nix package from the current directory.

Options:
  -L, --log       Show full build logs.
      --rebuild   Rebuild to check reproducibility.
      --cleanup   Cleanup results.
  -h, --help      Print help page.

Target:
  A .nix file or a flake installable, such as .#package.
  Defaults to the target where this script is in.
```

## Licensing
(C) 2026 CharOfString.

The packaging in this repository — the Nix expressions, `build-nix` and the documentation — is licensed under [MIT](./LICENSE).

The patches under [`nix/patches/`](./nix/patches) modify sources of the corresponding upstream projects and are provided under those projects' licenses:

| Patch | Upstream | License |
| --- | --- | --- |
| `dtk6core/0001-qt-6.11-file-engine.patch` | GXDE-OS/dtk6core | LGPL-3.0-or-later |
| `dtk6widget/0001-qt-6.10-private-api.patch` | GXDE-OS/dtk6widget | LGPL-3.0-or-later |
| `dtk6widget/0002-qt-6.11-completer-header.patch` | GXDE-OS/dtk6widget | LGPL-3.0-or-later |
