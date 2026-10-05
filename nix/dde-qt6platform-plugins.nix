{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  runCommand,
  cairo,
  dbus,
  libglvnd,
  libxkbcommon,
  mtdev,
  xorg,
  dtk5common,
}:

let
  inherit (import ./lib.nix { inherit lib; }) fixInstallPrefix;

  qt6XcbPrivateHeaders = runCommand "qt6-xcbqpa-private-headers-${qt6.qtbase.version}" { } ''
    mkdir -p $out
    tar -xf ${qt6.qtbase.src} --strip-components=5 -C $out \
      --wildcards '*/src/plugins/platforms/xcb/*'
    find $out -name '*.cpp' -delete
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dde-qt6platform-plugins";
  version = "6.0.48";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "dde-qt6platform-plugins";
    rev = "50a164557ce40ee46abb08f89c91f8e52520223d";
    hash = "sha256-I4SY5PJyfEk+Zd1Ts8Np+myxqdr82e62sw9xY3SzqqU=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    dbus
    libglvnd
    libxkbcommon
    mtdev
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilcursor
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
  ];

  propagatedBuildInputs = [
    qt6.qtbase
    dtk5common
  ];

  postPatch = fixInstallPrefix;

  cmakeFlags = [
    (lib.cmakeFeature "QT_XCB_PRIVATE_HEADERS" "${qt6XcbPrivateHeaders}")
    (lib.cmakeFeature "INSTALL_PATH"
      "${placeholder "out"}/${qt6.qtbase.qtPluginPrefix}/platforms")
  ];

  meta = {
    description = "Deepin/GXDE Qt6 XCB platform plugin (libdxcb)";
    homepage = "https://github.com/GXDE-OS/dde-qt6platform-plugins";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
