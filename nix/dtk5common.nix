{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtkcommon";
  version = "6.7.43";

  src = fetchFromGitHub {
    owner = "GXDE-OS";
    repo = "dtk5common";
    rev = "a19bd13d3c31d005ee51fd581048f108c959c1ed";
    hash = "sha256-L2EA51FCbeyOqJ3ewGBramZ8C5jzttXFVrLpkE85DtQ=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Shared configuration and CMake build support for GXDE DTK5/DTK6";
    homepage = "https://github.com/GXDE-OS/dtk5common";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
