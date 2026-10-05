{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  cups,
  xorg,
  libstartup_notification,
  dtk6core,
  dtk6gui,
}:

let
  inherit (import ./lib.nix { inherit lib; }) fixInstallPrefix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6widget";
  version = "6.0.48";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "dtk6widget";
    rev = "1a11fe5fa3acc97a3cd865e57000b45aefa85c6e";
    hash = "sha256-F3kE8S6SXTKMfxoB1UNS83ksH9zyY2gYrXqSOmCiqsM=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  patches = [
    ./patches/dtk6widget/0001-qt-6.10-private-api.patch
    ./patches/dtk6widget/0002-qt-6.11-completer-header.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
  ];

  buildInputs = [
    cups
    libstartup_notification
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.xcbutil
    qt6.qtsvg
  ];

  propagatedBuildInputs = [
    qt6.qtbase
    dtk6core
    dtk6gui
  ];

  postPatch = fixInstallPrefix;

  postInstall = ''
    moveToOutput "lib/qt6/mkspecs" "$dev"
    moveToOutput "lib/qt6/plugins" "$dev"
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCS" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "INSTALL_PLUGIN" true)
  ];

  meta = {
    description = "GXDE DTK6 Widget library";
    homepage = "https://github.com/GXDE-OS/dtk6widget";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
