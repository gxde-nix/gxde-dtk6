{
  description = "Nix packaging of GXDE DTK6 (dtk6log, dtk6core, dtk6gui, dtk6widget, dtk6declarative, dde-qt6platform-plugins, qt6integration)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "riscv64-linux" ];
    in
    {
      overlays.default = final: prev: {
        dtk6 = import ./default.nix { pkgs = final; };
      };
    }
    // flake-utils.lib.eachSystem systems
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          packages = import ./default.nix { inherit pkgs; };
        in
        {
          inherit packages;
          checks.dtk6 = packages.all;
        });
}
