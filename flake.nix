{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      perSystem = { pkgs, lib, config, system, ... }: {
        devShells.rvc-webui = pkgs.mkShell.override { stdenv = pkgs.llvmPackages_15.libcxxStdenv; } {
          buildInputs = with pkgs; [
            python38
            ffmpeg
            libffi
            aria2
            clang
            clang-tools_15
            llvmPackages_15.libstdcxxClang
            llvmPackages_15.libcxx
          ];
          NIX_CFLAGS_COMPILE = pkgs.lib.optionals pkgs.stdenv.isDarwin [
            "-I${pkgs.lib.getDev pkgs.libcxx}/include/c++/v1"
          ];
        };
      };
    };
}
