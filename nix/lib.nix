{ lib }:

{
  fixInstallPrefix = ''
    for f in misc/*.pc.in; do
      [ -e "$f" ] || continue
      sed -i 's|''${prefix}/\(@[A-Z_]*@\)|\1|g' "$f"
    done
    for f in misc/*.pri.in; do
      [ -e "$f" ] || continue
      sed -i 's|@CMAKE_INSTALL_PREFIX@/\(@[A-Z_]*@\)|\1|g' "$f"
    done
  '';
}
