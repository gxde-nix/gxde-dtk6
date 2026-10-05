{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  kdePackages,
  librsvg,
  wayland,
  wayland-scanner,
  dtk5common,
  dtk6core,
}:

let
  inherit (import ./lib.nix { inherit lib; }) fixInstallPrefix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6gui";
  version = "6.0.48";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "dtk6gui";
    rev = "03341acfb52ece10294a7c2baa61481d94121f3e";
    hash = "sha256-r2hOctR5eh+Ax3YLScmAg7WnkjblZCLxSEw4U/+0+wY=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    wayland-scanner
  ];

  buildInputs = [
    librsvg
    wayland
  ];

  propagatedBuildInputs = [
    qt6.qtbase
    qt6.qtwayland
    qt6.qtsvg
    dtk5common
    dtk6core
  ];

  postPatch = fixInstallPrefix;

  postInstall = ''
    moveToOutput "lib/qt6/mkspecs" "$dev"
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCS" false)
  ];

  meta = {
    description = "GXDE DTK6 Gui library";
    homepage = "https://github.com/GXDE-OS/dtk6gui";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
  };
})
