{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) lib;

  dtk5common = pkgs.callPackage ./nix/dtk5common.nix { };

  dtk6log = pkgs.callPackage ./nix/dtk6log.nix { };

  dtk6core = pkgs.callPackage ./nix/dtk6core.nix {
    inherit dtk5common dtk6log;
  };

  dtk6gui = pkgs.callPackage ./nix/dtk6gui.nix {
    inherit dtk5common dtk6core;
  };

  dtk6widget = pkgs.callPackage ./nix/dtk6widget.nix {
    inherit dtk6core dtk6gui;
  };

  dtk6declarative = pkgs.callPackage ./nix/dtk6declarative.nix {
    inherit dtk6core dtk6gui;
  };

  dde-qt6platform-plugins = pkgs.callPackage ./nix/dde-qt6platform-plugins.nix {
    inherit dtk5common;
  };

  qt6integration = pkgs.callPackage ./nix/qt6integration.nix {
    inherit dtk6widget;
    libqtxdg = pkgs.lxqt.libqtxdg;
  };

  modules = [
    dtk5common
    dtk6log
    dtk6core
    dtk6gui
    dtk6widget
    dtk6declarative
    dde-qt6platform-plugins
    qt6integration
  ];

  all = pkgs.symlinkJoin {
    name = "gxde-dtk6-${dtk6widget.version}";
    paths = lib.concatMap (p: [ p (lib.getDev p) ]) modules;
  };
in
{
  inherit
    dtk5common
    dtk6log
    dtk6core
    dtk6gui
    dtk6widget
    dtk6declarative
    dde-qt6platform-plugins
    qt6integration
    all
    ;

  default = all;
}
