{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  libX11,
  glib,
  libqtxdg,
  mtdev,
  dtk6widget,
}:

let
  inherit (import ./lib.nix { inherit lib; }) fixInstallPrefix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qt6integration";
  version = "6.0.35";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "qt6integration";
    rev = "3160a37c8cdcc36c0081e16e9d90c7317b59a502";
    hash = "sha256-hKTvul/WBjVf1R1hZogsDT2EUps+dIYayNDPDgq3DpQ=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    libqtxdg
    mtdev
    qt6.qtsvg
    libX11
  ];

  propagatedBuildInputs = [
    qt6.qtbase
    dtk6widget
  ];

  postPatch = fixInstallPrefix;

  cmakeFlags = [
    (lib.cmakeFeature "DTK_VERSION" finalAttrs.version)
    (lib.cmakeFeature "PLUGIN_INSTALL_BASE_DIR"
      "${placeholder "out"}/${qt6.qtbase.qtPluginPrefix}")
  ];

  meta = {
    description = "Deepin/GXDE Qt6 platform integration plugins (iconengines, imageformats, platformthemes, styles)";
    homepage = "https://github.com/GXDE-OS/qt6integration";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
