{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  dbus,
  icu,
  libuchardet,
  systemdLibs,
  dtk5common,
  dtk6log,
  withSystemd ? stdenv.hostPlatform.isLinux,
}:

let
  inherit (import ./lib.nix { inherit lib; }) fixInstallPrefix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6core";
  version = "6.0.48";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "dtk6core";
    rev = "c8c20a0edc3bc3809cb63a3bfeffaed5dec7e952";
    hash = "sha256-nkckiwWF2zZviHWgaJ9IhMNjv/009Qc6AZVD6mkzBT4=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  patches = [ ./patches/dtk6core/0001-qt-6.11-file-engine.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dbus
    icu
    libuchardet
  ] ++ lib.optionals withSystemd [ systemdLibs ];

  propagatedBuildInputs = [
    qt6.qtbase
    dtk5common
    dtk6log
  ];

  postPatch = fixInstallPrefix;

  postInstall = ''
    moveToOutput "lib/qt6/mkspecs" "$dev"
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCS" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
    (lib.cmakeBool "BUILD_WITH_SYSTEMD" withSystemd)
  ];

  meta = {
    description = "GXDE DTK6 Core library";
    homepage = "https://github.com/GXDE-OS/dtk6core";
    license = with lib.licenses; [ lgpl3Plus lgpl21Plus bsd3 ];
    platforms = lib.platforms.linux;
  };
})
