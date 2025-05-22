{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flakeUtils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flakeUtils,
    environments,
  }:
    flakeUtils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        packages = with pkgs; [
        ];

        libs = with pkgs; [
          zlib
          stdenv.cc.cc.lib
          glib
        ];

        mlibs = with pkgs; [
          # for matplotlib to fucking work
          fontconfig
          xorg.libX11
          libxkbcommon
          freetype
          dbus
        ];
        ld_path = "${pkgs.lib.makeLibraryPath libs}";
        shellHook = ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${ld_path}"
        '';
      in {
        devShells = {
          python-deps = pkgs.mkShell {
            inherit shellHook;
            buildInputs = libs;
          };

          matplotlib = pkgs.mkShell {
            inherit shellHook;
            buildInputs = libs ++ mlibs;
          };
        };
      }
    );
}
