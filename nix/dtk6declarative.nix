{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  libglvnd,
  dtk6core,
  dtk6gui,
}:

let
  inherit (import ./lib.nix { inherit lib; }) fixInstallPrefix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6declarative";
  version = "6.0.48";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "dtk6declarative";
    rev = "af444c3e16964764a39087adb6e6a6777263d59e";
    hash = "sha256-dEoLus5/3DjvUMPjHMqk62lZu8kLnomWT+75/4b1xzU=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
  ];

  buildInputs = [
    libglvnd
  ];

  propagatedBuildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtshadertools
    dtk6core
    dtk6gui
  ];

  postPatch = fixInstallPrefix;

  postInstall = ''
    moveToOutput "lib/qt6/mkspecs" "$dev"
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCS" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
  ];

  meta = {
    description = "GXDE DTK6 Declarative (QtQuick) modules";
    homepage = "https://github.com/GXDE-OS/dtk6declarative";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
