{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  spdlog,
  systemdLibs,
  withSystemd ? stdenv.hostPlatform.isLinux,
}:

let
  inherit (import ./lib.nix { inherit lib; }) fixInstallPrefix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6log";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "dtk6log";
    rev = "2d60b04b377bf0a3a7ffcfc71f07947446945efc";
    hash = "sha256-q2F9G+0OB6FIzFRohvRELova/lbHYrh4Da1j2IAuvPY=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    spdlog
  ] ++ lib.optionals withSystemd [ systemdLibs ];

  propagatedBuildInputs = [ qt6.qtbase ];

  postPatch = ''
    ${fixInstallPrefix}
    sed -i 's|include(CMakeFindDependencyMacro)|include(CMakeFindDependencyMacro)\nfind_dependency(Qt@QT_VERSION_MAJOR@ COMPONENTS Core)|' \
      misc/DLogConfig.cmake.in
  '';

  postInstall = ''
    moveToOutput "lib/qt6/mkspecs" "$dev"
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_QT6" true)
    (lib.cmakeBool "BUILD_WITH_SYSTEMD" withSystemd)
  ];

  meta = {
    description = "Simple, convenient and thread safe logger for Qt6-based C++ applications (GXDE DTK6)";
    homepage = "https://github.com/GXDE-OS/dtk6log";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
  };
})
